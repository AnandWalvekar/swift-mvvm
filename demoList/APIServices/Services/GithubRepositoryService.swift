
import Foundation

protocol RepositoryService {
    func getRepositories(userId: String) async throws -> GetRepositoryListResponse
}

class GithubRepositoryService: RepositoryService {
    func getRepositories(userId: String) async throws -> GetRepositoryListResponse  {
        let repositories: GetRepositoryListResponse = try await APIClient.shared.fetch(request: GetRepositoryListRequest(path: "users/\(userId)/repos"))
            return repositories
    }
}
