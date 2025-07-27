


class InMemoryTokenService: TokenService {
    private(set) var accessToken: String
    private(set) var refreshToken: String
    
    init(accessToken: String, refreshToken: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
    }
    
    func getAccessToken() -> String {
        return accessToken
    }
    
    func saveAccessToken(token: String) {
        self.accessToken = token
    }
    
    func getRefreshToken() -> String {
        return refreshToken
    }
    
    func saveRefreshToken(token: String) {
        self.refreshToken = token
    }
    
}
