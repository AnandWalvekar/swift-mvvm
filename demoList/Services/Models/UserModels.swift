
import Foundation



struct GetUsersRequest: Request {    
    let path: String = "users"
}

typealias GetUsersResponse = [User]

struct UserDetailsRequest: Request {
    let path: String
}

struct UserDetailsResponse: Decodable {
    let login: String
    let avatarUrl: String
    let followers: Int
    let following: Int
    
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case followers
        case following
    }
}


struct User: Codable {
    let login: String
    let avatarUrl: String
    
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

extension User {
    static var sampleList: [User] {
        return [User(login: "Test", avatarUrl:"https://avatars.githubusercontent.com/u/19?v=4")]
    }
}






