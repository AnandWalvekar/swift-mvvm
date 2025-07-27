
import Foundation

protocol APIClientHelper {
    func resolvedUrl(path: String, cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval) throws -> URLRequest
    func decode<T: Decodable>(data: Data) async throws -> T
}

enum Enviroment : String, APIClientHelper {
    case development
    case production
    
    var baseUrl: String {
        switch self {
        case .development:
            return "https://api.github.com"
        case .production:
            return "https://api.github.com"
        }
    }
    
    //Pure fuction : Testable
    func resolvedUrl(path: String, cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval) throws -> URLRequest {
        let urlString = "\(self.baseUrl)/\(path)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlError(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        
        return URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    //Pure fuction : Testable
    func decode<T: Decodable>(data: Data) async throws -> T {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

}

enum NetworkError: Error {
    case urlError(Error)
    case decodingError(Error)
    case invalidResponse
    case clientError(Int)
    case serverError(Int)
}

protocol Request {
    var path: String { get }
    var method: Method { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
}

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

extension Request {    
    var method: Method { return .GET }
    var body: Data? { nil }
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
}

protocol APIClientService {
    func fetch<T: Decodable>(request: Request) async throws ->  T
}

struct APIClient : APIClientService {
    static var shared = APIClient()
    private let environment: Enviroment = .development
    let cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    let timeoutInterval: TimeInterval = 60.0
    private var tokenService: TokenService!
        
    private init() {}
    
    static func configure(tokenService: TokenService) {
        shared.tokenService = tokenService
    }
    
    func fetch<T: Decodable>(request: Request) async throws ->  T {
        var urlRequest = try environment.resolvedUrl(path: request.path, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("Bearer \(tokenService.getAccessToken())", forHTTPHeaderField: "Authorization")
        
        do {
            let data: (Data, URLResponse) = try await URLSession.shared.data(for: urlRequest)
            if let response = data.1 as? HTTPURLResponse {
                if (response.statusCode == 401) {
                    throw NetworkError.clientError(response.statusCode)
                }
            }
            let decoded: T = try await environment.decode(data: data.0)
            return decoded
        } catch {
            throw NetworkError.urlError(error)
        }
    }
}

struct RetryingAPIClient : APIClientService {
    let client: APIClientService
    
    init(client: APIClientService, refreshToken: String? = nil) {
        self.client = client
    }
    
    func fetch<T: Decodable>(request: Request) async throws ->  T {
        do {
            let response: T = try await client.fetch(request: request)
            return response
        } catch {
            switch error {
            case let NetworkError.clientError(statusCode):
                if statusCode == 401 {
                    let response: RefreshTokenResponse = try await client.fetch(request: RefreshTokenRequest())
                    if !response.accessToken.isEmpty {
                        let response: T = try await client.fetch(request: request)
                        return response
                    }
                }
            default:
                throw NetworkError.urlError(error)
            }
            throw NetworkError.urlError(error)
        }
    }
}
