
import Foundation
import Combine

protocol NYTimesAPIFetchable {
    func fetch(method: NYTimesAPI.Method, period: NYTimesAPI.Method.Period) -> AnyPublisher<Data, Error>
}

final class NYTimesAPI: NYTimesAPIFetchable {
    private let apiKey = "2pxffUsNNhwYPfnuQB7OnF1gKy9jQ18B" // Set your API key here
    private let scheme = "https"
    private let host   = "api.nytimes.com"
    
    private let apiExtension = "json"
    private let urlRequestTimeoutInterval: TimeInterval = 5
    
    private let networkFetchingQueue = DispatchQueue(label: "networkFetching")
    
    func fetch(method: Method, period: Method.Period) -> AnyPublisher<Data, Error> {
        guard let request = makeURLRequest(method: method, period: period) else {
            return Fail(error: NetworkError.wrongURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: networkFetchingQueue)
            .tryMap(NetworkError.processResponse)
            .eraseToAnyPublisher()
    }

    private func makeURL(for method: Method, period: Method.Period) -> URL? {
        let fullPath = method.path + period.path
        
        var url = URL(scheme:     scheme,
                      host:       host,
                      path:       fullPath,
                      parameters: ["api-key": apiKey])
        
        url?.appendPathExtension(apiExtension)
        return url
    }
    
    private func makeURLRequest(method: Method, period: Method.Period) -> URLRequest? {
        guard let url = makeURL(for: method, period: period) else { return nil }
        
        return URLRequest(
            url: url,
            timeoutInterval: urlRequestTimeoutInterval)
    }
}

extension NYTimesAPI {
    enum Method: String, CaseIterable, Identifiable {
        case viewed  = "viewed"
        case shared  = "shared"
        case emailed = "emailed"
        
        private static let basePath = "/svc/mostpopular/v2"
        
        var path: String { Self.basePath + "/" + self.rawValue }
        
        var id: String { self.rawValue }
    }
}

extension NYTimesAPI.Method {
    enum Period: String, CaseIterable, Identifiable {
        case day   = "day"
        case week  = "week"
        case month = "month"
        
        var path: String {
            switch self {
            case .day:
                return "/1"
            case .week:
                return "/7"
            case .month:
                return "/30"
            }
        }
        
        var id: String { self.rawValue }
    }
}

extension NYTimesAPI.Method.Period: CustomStringConvertible {
    var description: String {
        switch self {
        case .day, .week:
            return "of the " + self.rawValue
        case .month:
            return "in a " + self.rawValue
        }
    }
}
