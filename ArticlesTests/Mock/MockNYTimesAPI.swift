
@testable import Articles
import Foundation

import Combine

class MockNYTimesAPI: NYTimesAPIFetchable {
    enum JsonType {
        // JSON
        case correctJSON
        case correctCustomJSON
        case wrongJSON
        
        //Error
        case wrongURL
        case unknown
        case message(reason: String)
        case noInternet
        case parseError
        case timeout
    }
    
    var jsonString: String
    var error: Error?
    
    init(type: JsonType) {
        self.jsonString = ""
        self.error = nil
        
        switch type {
        case .correctJSON:
            self.jsonString = StubArticleJSON.correct
        case .correctCustomJSON:
            self.jsonString = StubArticleJSON.correctCustom
        case .wrongJSON:
            self.jsonString = StubArticleJSON.wrong
        case .unknown:
            self.error = NetworkError.unknown
        case .wrongURL:
            self.error = NetworkError.wrongURL
        case .message(reason: let reason):
            self.error = NetworkError.message(reason: reason)
        case .noInternet:
            self.error = URLError(.notConnectedToInternet)
        case .parseError:
            self.error = Swift.DecodingError.self as? Error
        case .timeout:
            self.error = URLError(.timedOut)
        }
    }

    func fetch(method: NYTimesAPI.Method, period: NYTimesAPI.Method.Period) -> AnyPublisher<Data, Error> {
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(jsonString.data(using: .utf8)!)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
