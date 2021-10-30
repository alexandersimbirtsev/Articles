
@testable import Articles
import XCTest

class NYTimesAPITests: XCTestCase {

    // MARK:  Positive
    
    func testSuccessfullyCreateURLsToAllNYTimesAPIMethods() throws {
        // Given
        let scheme     = "https"
        let host       = "api.nytimes.com"
        let parameters = ["api-key": "evt234t254yyyfy5fw4w"]

        let methods = NYTimesAPI.Method.allCases.map { $0.path }
        let periods = NYTimesAPI.Method.Period.allCases.map { $0.path }
        
        let paths = methods.flatMap { method in
            periods.map { method + $0 }
        }

        // When
        paths.forEach { path in
            // Then
            XCTAssertNotNil(
                URL(scheme: scheme, host: host, path: path, parameters: parameters),
                "URL with path: \(path) initialization failed")
        }
    }
}
