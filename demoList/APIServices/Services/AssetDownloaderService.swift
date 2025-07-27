
import Foundation

protocol AssetDownloaderService {
    func getAsset(url: String) async throws -> Data
}

// Simple downloader without timeout, cache, error handling
class AssetDownloader : AssetDownloaderService {
    func getAsset(url: String) async throws -> Data  {
        let response = try await URLSession.shared.data(from: URL(string: url)!)
        return response.0
    }
}
