import Foundation

enum FetchDataError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError
    case networkError(error: Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "❌ Error: Invalid URL"
        case .invalidResponse(let statusCode):
            return "❌ Error: Invalid Response - Status Code: \(statusCode)"
        case .noData:
            return "❌ Error: No Data"
        case .decodingError:
            return "❌ Error: Decoding Error"
        case .networkError(let error):
            return "❌ Network Error: \(error.localizedDescription)"
        }
    }
}

