
import SwiftUI

final class SettingsController: ObservableObject {
    @Published var articlesCacheSize = ""
    @Published var imagesCacheSize = ""
    
    private let cache: FileCacheable
    
    init(cache: FileCacheable = FileCache()) {
        self.cache = cache
    }
    
    func setAllCacheSize() {
        setArticlesCacheSize()
        setImagesCacheSize()
    }
    
    func deleteAllCache() {
        removeCache(at: .articles)
        removeCache(at: .images)
        
        setAllCacheSize()
    }
    
    func deleteArticlesCache() {
        removeCache(at: .articles)
        setArticlesCacheSize()
    }
    
    func deleteImagesCache() {
        removeCache(at: .images)
        setImagesCacheSize()
    }
    
    private func setArticlesCacheSize() {
        let directoryURL = cache.directoryURL
            .appendingPathComponent(CachePath.articles.rawValue)
        
        articlesCacheSize = cache.sizeDescription(of: directoryURL)
    }
    
    private func setImagesCacheSize() {
        let directoryURL = cache.directoryURL
            .appendingPathComponent(CachePath.images.rawValue)
        
        imagesCacheSize = cache.sizeDescription(of: directoryURL)
    }
    
    private func removeCache(at path: CachePath) {
        let directoryURL = cache.directoryURL
            .appendingPathComponent(path.rawValue)
        
        cache.remove(at: directoryURL)
    }
}
