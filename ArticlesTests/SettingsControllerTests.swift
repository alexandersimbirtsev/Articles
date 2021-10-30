
@testable import Articles
import XCTest

class SettingsControllerTests: XCTestCase {

    // MARK:  Positive
    
    func testSuccessfullySetAllCacheSize() throws {
        // Given
        let tempCache = MockFileCache()
        let articlesDirectoryString = tempCache.directoryURL
            .appendingPathComponent(CachePath.articles.rawValue)
            .absoluteString
        
        let articlesData = articlesDirectoryString.data(using: .utf8)!
        
        let imagesDirectoryString = tempCache.directoryURL
            .appendingPathComponent(CachePath.images.rawValue)
            .absoluteString
        
        let imagesData = imagesDirectoryString.data(using: .utf8)!
        
        let cache = MockFileCache(with: [
            (articlesDirectoryString, articlesData),
            (imagesDirectoryString, imagesData)
        ])
        let sut = SettingsController(cache: cache)
        
        
        // When
        sut.setAllCacheSize()
        
        // Then
        XCTAssertFalse(sut.articlesCacheSize.isEmpty)
        XCTAssertFalse(sut.imagesCacheSize.isEmpty)
    }
    
    func testSuccessfullyDeleteAllCache() throws {
        // Given
        let cache = MockFileCache()
        let sut = SettingsController(cache: cache)
        sut.articlesCacheSize = "100 mb"
        sut.imagesCacheSize = "800 mb"
        
        // When
        sut.deleteAllCache()
        
        // Then
        XCTAssertTrue(sut.articlesCacheSize.isEmpty)
        XCTAssertTrue(sut.imagesCacheSize.isEmpty)
    }
    
    func testSuccessfullyDeleteArticlesCache() throws {
        // Given
        let tempCache = MockFileCache()
        let articlesDirectoryString = tempCache.directoryURL
            .appendingPathComponent(CachePath.articles.rawValue)
            .absoluteString
        
        let articlesData = articlesDirectoryString.data(using: .utf8)!
        
        let imagesDirectoryString = tempCache.directoryURL
            .appendingPathComponent(CachePath.images.rawValue)
            .absoluteString
        
        let imagesData = imagesDirectoryString.data(using: .utf8)!
        
        let cache = MockFileCache(with: [
            (articlesDirectoryString, articlesData),
            (imagesDirectoryString, imagesData)
        ])
        let sut = SettingsController(cache: cache)
        sut.articlesCacheSize = "100 MB"
        sut.imagesCacheSize = "100 MB"
        
        // When
        sut.deleteArticlesCache()
        
        // Then
        XCTAssertTrue(sut.articlesCacheSize.isEmpty)
        XCTAssertFalse(sut.imagesCacheSize.isEmpty)
    }
    
    func testSuccessfullyDeleteImagesCache() throws {
        // Given
        let tempCache = MockFileCache()
        let articlesDirectoryString = tempCache.directoryURL
            .appendingPathComponent(CachePath.articles.rawValue)
            .absoluteString
        
        let articlesData = articlesDirectoryString.data(using: .utf8)!
        
        let imagesDirectoryString = tempCache.directoryURL
            .appendingPathComponent(CachePath.images.rawValue)
            .absoluteString
        
        let imagesData = imagesDirectoryString.data(using: .utf8)!
        
        let cache = MockFileCache(with: [
            (articlesDirectoryString, articlesData),
            (imagesDirectoryString, imagesData)
        ])
        let sut = SettingsController(cache: cache)
        sut.articlesCacheSize = "100 MB"
        sut.imagesCacheSize = "100 MB"
        
        // When
        sut.deleteImagesCache()
        
        // Then
        XCTAssertFalse(sut.articlesCacheSize.isEmpty)
        XCTAssertTrue(sut.imagesCacheSize.isEmpty)
    }
}
