
@testable import Articles
import XCTest

import Combine

class ArticlesControllerTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subscriptions = []
    }
    
    // MARK:  Positive
    
    func testArticlesFetchedFromNetwork() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .correctJSON)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$articles
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { _ in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
        
        // Then
        XCTAssertFalse(sut.articles.isEmpty, "Articles from network not received")
    }
    
    func testCustomArticlesFetchedFromNetwork() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .correctCustomJSON)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$articles
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { _ in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
        
        // Then
        XCTAssertFalse(sut.articles.isEmpty, "Articles from network not received")
    }
    
    func testArticlesFetchedFromCacheAndNetwork() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .correctJSON)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from cache and network")
        let expectedFetchedTimes = 2
        var fetchedTimes = 0

        // When
        sut.fetchArticlesFromCacheAndNetwork()
        
        sut.$articles
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { articles in
                fetchedTimes += 1
                
                if expectedFetchedTimes == fetchedTimes {
                    promise.fulfill()
                    return
                }
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 2)
        
        // Then
        XCTAssertEqual(expectedFetchedTimes, fetchedTimes, "Articles not received two times")
        XCTAssertFalse(sut.articles.isEmpty, "Articles from cache and network not received")
    }
    
    // MARK:  Negative
    
    func testArticlesNotFetchedFromNetworkWithMessageWithReasonError() throws {
        // Given
        let expectedErrorReason = "TDD"
        let fetcher = MockNYTimesAPI(type: .message(reason: expectedErrorReason))
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { _ in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 0.5)
        
        // Then
        XCTAssertTrue(sut.articles.isEmpty, "Articles from network received")
        XCTAssertNotNil(sut.error, "No error")
        XCTAssertTrue(sut.error as? NetworkError == NetworkError.message(reason: expectedErrorReason), "This is not a NetworkError.message")
    }
    
    func testArticlesNotFetchedFromNetworkWithWrongURLError() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .wrongURL)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { fail in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 0.5)
        
        // Then
        XCTAssertTrue(sut.articles.isEmpty, "Articles from network received")
        XCTAssertNotNil(sut.error, "No error")
        XCTAssertTrue(sut.error as? NetworkError == NetworkError.wrongURL, "This is not a NetworkError.unknown")
    }
    
    func testArticlesNotFetchedFromNetworkWithUnknownError() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .unknown)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { fail in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 0.5)
        
        // Then
        XCTAssertTrue(sut.articles.isEmpty, "Articles from network received")
        XCTAssertNotNil(sut.error, "No error")
        XCTAssertTrue(sut.error as? NetworkError == NetworkError.unknown, "This is not a NetworkError.unknown")
    }
    
    func testArticlesNotFetchedFromNetworkWithTimeoutError() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .timeout)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { fail in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 0.5)
        
        // Then
        XCTAssertTrue(sut.articles.isEmpty, "Articles from network received")
        XCTAssertNotNil(sut.error, "No error")
        XCTAssertTrue(sut.error as? NetworkError == NetworkError.timeout, "This is not a NetworkError.timeout")
    }
    
    func testArticlesNotFetchedFromNetworkWithParseError() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .parseError)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { fail in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
        
        // Then
        XCTAssertTrue(sut.articles.isEmpty, "Articles from network received")
        XCTAssertNotNil(sut.error, "No error")
        XCTAssertTrue(sut.error as? NetworkError == NetworkError.parseError, "This is not a NetworkError.parseError")
    }
    
    func testArticlesNotFetchedFromNetworkWithNoInternetError() throws {
        // Given
        let fetcher = MockNYTimesAPI(type: .noInternet)
        let sut = ArticlesController(fetcher: fetcher)
        let promise = expectation(description: "fetching articles from network")
        
        // When
        sut.fetchArticlesFromNetwork()
        
        sut.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { fail in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
        
        // Then
        XCTAssertTrue(sut.articles.isEmpty, "Articles from network received")
        XCTAssertNotNil(sut.error, "No error")
        XCTAssertTrue(sut.error as? NetworkError == NetworkError.noInternet, "This is not a NetworkError.noInternet")
    }
}
