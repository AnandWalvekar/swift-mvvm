
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
    func resolvedUrl(path: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0) throws -> URLRequest {
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

class APIClient {
    static let shared = APIClient()
    private let environment: Enviroment = .development
    let cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    let timeoutInterval: TimeInterval = 60.0
    
    private init() {}
    
    func fetch<T: Decodable>(request: Request) async throws ->  T {
        var urlRequest = try environment.resolvedUrl(path: request.path)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("Bearer \(Constants.githubPersoanlAcesssToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let data: (Data, URLResponse) = try await URLSession.shared.data(for: urlRequest)
            let decoded: T = try await environment.decode(data: data.0)
            return decoded
        } catch {
            throw NetworkError.urlError(error)
        }
    }
    
}

