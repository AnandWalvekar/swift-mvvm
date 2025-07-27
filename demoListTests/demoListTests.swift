
import Testing
@testable import demoList
import Foundation

struct demoListTests {

    struct APIServiceTest {
        @Test func checkBaseUrl() async throws {
            // Write your test here and use APIs like `#expect(...)` to check expected conditions.
            let environment: Enviroment = .development
            
            #expect(environment.baseUrl == "https://gist.githubusercontent.com")
        }

        @Test func checkResolvedPath() async throws {
            // Write your test here and use APIs like `#expect(...)` to check expected conditions.
            let environment: Enviroment = .development
            let urlRequest = try environment.resolvedUrl(path: "path")
            
            #expect(urlRequest == URLRequest(url: URL(string: "https://gist.githubusercontent.com/path")!))
        }
    }
    
    struct ViewModelTest {
        @Test
        func checkApiToDomainModel() async throws {
            let countyListViewModel = UserListViewModel(userService: GithubUserService())
            countyListViewModel.convertToDomainModel(apiResponse: User.sampleList)
            #expect(countyListViewModel.users.count == 1)
            
        }
    }
}
