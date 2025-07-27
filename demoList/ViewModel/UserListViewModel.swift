
protocol UserListVM: AnyObject {
    func fetchUsers() async
    var users: [UserDM] { get }
    func filteredCounties(searchText: String?) -> [UserDM]
}

class UserListViewModel: UserListVM {
    private(set) var users: [UserDM]
    private let userService: UserService
        
    init (userService: UserService) {
        self.userService = userService
        self.users = []
    }
    
    func fetchUsers() async {
        do {
            let apiResponse = try await userService.getUsers()
            convertToDomainModel(apiResponse: apiResponse)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func filteredCounties(searchText: String?) -> [UserDM] {
        if searchText == nil {
            return users
        }
        
        if searchText!.isEmpty {
            return users
        }
        
        let lowercasedSearchText = searchText!.lowercased()
        return users.filter { user in
            return user.name.lowercased().contains(lowercasedSearchText) ||
            user.name.lowercased().contains(lowercasedSearchText)
        }
    }
    
    
    func convertToDomainModel(apiResponse: GetUsersResponse) {
        // Map api response to View requirement
        self.users = apiResponse.map({ user in
            UserDM(getUsersResponse: user)
        })
    }        
}
