
import Foundation

enum LinkedUserType: String {
    case followers
    case following
}

protocol UserService {
    func getUsers() async throws -> GetUsersResponse
    func getUserDetails(userName: String) async throws -> UserDetailsResponse
    func getAssociatedUsers(userName: String, linkedUserType: LinkedUserType) async throws -> GetUsersResponse
}

class GithubUserService: UserService {
    func getUsers() async throws -> GetUsersResponse  {
            let users: GetUsersResponse = try await APIClient.shared.fetch(request: GetUsersRequest())
            return users
    }
    
    func getUserDetails(userName: String) async throws -> UserDetailsResponse {
        let user: UserDetailsResponse = try await APIClient.shared.fetch(request: UserDetailsRequest(path: "users/\(userName)"))
        return user
    }
    
    func getAssociatedUsers(userName: String, linkedUserType: LinkedUserType) async throws -> GetUsersResponse {
        let path = "users/\(userName)/\(linkedUserType.rawValue)"
        let users: GetUsersResponse = try await APIClient.shared.fetch(request: GetUsersRequest())
        return users
    }
}
