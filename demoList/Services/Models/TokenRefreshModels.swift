struct RefreshTokenRequest: Request {
    let path: String = "/oauth2/token"
}

struct RefreshTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
