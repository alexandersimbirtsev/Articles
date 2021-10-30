
import Foundation

enum NetworkError: Error, Equatable {
    case wrongURL
    case unknown
    case message(reason: String)
    case parseError
    case noInternet
    case timeout
    
    static func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401, 404:
            throw Self.message(reason: "Service unavailable")
        case 429:
            throw Self.message(reason: "Too many requests. You reached your per minute or per day rate limit")
        default:
            throw Self.unknown
        }
    }
    
    static func handleError(_ failureError: Error) -> NetworkError {
        switch failureError {
        case is Swift.DecodingError:
            return .parseError
        case let error as URLError where error.code == URLError.Code.notConnectedToInternet:
            return .noInternet
        case let error as URLError where error.code == URLError.Code.timedOut:
            return .timeout
        case let error as NetworkError:
            return error
        default:
            return .unknown
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongURL, .parseError:
            return "Service unavailable"
        case .unknown:
            return "Something went wrong"
        case .message(reason: let reason):
            return reason
        case .noInternet:
            return "No internet connection"
        case .timeout:
            return "Timeout internet connection"
        }
    }
}
