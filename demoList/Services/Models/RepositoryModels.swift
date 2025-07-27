
import Foundation

struct GetRepositoryListRequest: Request {
    let path: String
}

typealias GetRepositoryListResponse = [Repository]

struct Repository: Codable {
    let name: String
    let language: String?
    let owner: Owner
    let cloneUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case cloneUrl = "clone_url"
        case owner
        case language
    }
}

struct Owner: Codable {
    let imageUrl: String
    enum CodingKeys: String, CodingKey {
        case imageUrl = "avatar_url"
    }
}
