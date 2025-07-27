
import Foundation


struct UserDM {
    let name: String
    let imageUrl: String
    
    init(getUsersResponse: User) {
        self.name = getUsersResponse.login
        self.imageUrl = getUsersResponse.avatarUrl
    }
}

struct UserDetailsDM {
    let name: String
    let imageUrl: String
    var followersCount: Int = 0
    var followingCount: Int = 0
    
    init(user: UserDM) {
        self.name = user.name
        self.imageUrl = user.imageUrl
    }
}
