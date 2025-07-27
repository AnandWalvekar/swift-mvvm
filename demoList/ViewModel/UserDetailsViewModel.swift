import Observation
import UIKit

protocol UserDetailsVM: AnyObject {
    var repoService: RepositoryService { get }
    var repositories: [RepositoryDM] { get }
    var userDetailsDM: UserDetailsDM? { get }
    var avatarImage: UIImage? { get }
    func fetchUserDetails()
}

@Observable
class UserDetailsViewModel: UserDetailsVM {
    private(set) var repoService: RepositoryService
    private(set) var userService: UserService
    private(set) var assetDownloaderService: AssetDownloaderService
    private(set) var userDM: UserDM
    private(set) var avatarImage: UIImage?
    var repositories: [RepositoryDM] = []
    var userDetailsDM: UserDetailsDM?
    
    init(userDM: UserDM, userService: UserService, repoService: RepositoryService, assetDownloaderService: AssetDownloaderService) {
        self.userService = userService
        self.repoService = repoService
        self.assetDownloaderService = assetDownloaderService
        self.userDM = userDM
    }
    
    func fetchUserDetails()  {
        fetchRepositories()
        fetchFollowersAndFollowing()
        fetchAvatarImage()
    }
    
    private func fetchRepositories()  {
        Task {
            do {
                let repos = try await repoService.getRepositories(userId: userDM.name)
                repositories = repos.map({item in RepositoryDM(repository: item)})
                print("repositories: \(repositories.count)")
            } catch {
                print("Handling error in view model")
            }
        }
    }
    
    private func fetchAvatarImage()  {
        Task {
            do {
                let imageData = try await assetDownloaderService.getAsset(url: userDM.imageUrl)
                avatarImage = UIImage(data: imageData)!
                print("image: \(imageData)")
            } catch {
                print("Handling error in view model")
            }
        }
    }
        
    private func fetchFollowersAndFollowing()  {
        Task {
            do {
                
                let user = try await userService.getUserDetails(userName: userDM.name)
//                async let followers = userService.getAssociatedUsers(userName: userDM.name, linkedUserType: .followers)
//                async let following = userService.getAssociatedUsers(userName: userDM.name, linkedUserType: .following)
//                
//                // Concurrently perform both api requests
//                let linkedUser = try await [followers, following]
//                
//                userDetailsDM = UserDetailsDM(user: userDM)
                userDetailsDM?.followersCount = user.followers
                userDetailsDM?.followingCount = user.following
                print("followers/following: \(userDetailsDM?.followersCount) \(userDetailsDM?.followingCount)")
            } catch {
                print("Handling error in view model")
            }
        }
    }
}
