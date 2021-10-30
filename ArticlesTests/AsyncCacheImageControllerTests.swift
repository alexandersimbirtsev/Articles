
@testable import Articles
import XCTest
import Combine

class AsyncCacheImageControllerTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subscriptions = []
    }
    
    // MARK:  Positive
    
    func testFetchImageFromNetwork() throws {
        // Given
        let url = URL(string: "https://static01.nyt.com/images/2021/10/31/business/31GenZ-illo/31GenZ-illo-thumbStandard-v2.jpg")
        let fetcher = MockImageFetcher()
        let cache = MockFileCache()
        let sut = AsyncCacheImageController(url: url, fetcher: fetcher, cache: cache)
        let promise = expectation(description: "fetching image from network")
        
        // When
        sut.fetch()
        
        sut.$uiImage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                XCTFail()
            }, receiveValue: { _ in
                promise.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
        
        // Then
        XCTAssertNotNil(sut.uiImage, "There is no image")
        XCTAssertEqual(sut.state, AsyncCacheImageController.State.success, "Image fetching state is not .success")
    }
    
    // MARK:  Negative
    
    func testFetchImageFromNetworkWithNilURL() throws {
        // Given
        let fetcher = MockImageFetcher()
        let cache = MockFileCache()
        let sut = AsyncCacheImageController(url: nil, fetcher: fetcher, cache: cache)
        let promise = expectation(description: "fetching image from network")
        
        // When
        sut.fetch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            promise.fulfill()
        }

        wait(for: [promise], timeout: 2)
        
        // Then
        XCTAssertNil(sut.uiImage, "Image found")
        XCTAssertEqual(sut.state, AsyncCacheImageController.State.none, "Image fetching state is not .none")
    }
}
