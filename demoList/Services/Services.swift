
protocol TokenService {
    func getAccessToken() -> String
    func saveAccessToken(token: String)
    
    func getRefreshToken() -> String
    func saveRefreshToken(token: String)
}
