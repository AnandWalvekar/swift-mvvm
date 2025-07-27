
import UIKit

struct Router {
    static func mainViewController() -> UIViewController {
        let countriesViewController = UserListController(UserListViewModel(userService:GithubUserService()))
        countriesViewController.onSelectUser = userDetailsViewController
        return countriesViewController
    }
    
    private static func userDetailsViewController(userDM : UserDM) -> UIViewController {
        // Service to pass as dependency
        let userSerice = GithubUserService()
        let repoService = GithubRepositoryService()
        let assetService = AssetDownloader()
        
        //view model with service injection
        let vm = UserDetailsViewModel(userDM : userDM, userService: userSerice, repoService: repoService, assetDownloaderService: assetService)
        
        // view controller with view model
        let vc = UserDetailsViewController(vm, userDM: userDM)
        return vc
    }
    
}
