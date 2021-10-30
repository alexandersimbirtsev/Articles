
import Combine
import SwiftUI

final class ArticlesController: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    @AppStorage(AppStorageKeys.method.rawValue) var method: NYTimesAPI.Method = .viewed {
        didSet { fetchArticlesFromCacheAndNetwork() }
    }
    
    @AppStorage(AppStorageKeys.period.rawValue) var period: NYTimesAPI.Method.Period = .day {
        didSet { fetchArticlesFromCacheAndNetwork() }
    }
    
    var redactedReason: RedactionReasons { isLoading ? .placeholder : [] }
    
    private let cachedArticlesQueue = DispatchQueue(label: "cachedArticles")
    private var cancellableGetArticles: AnyCancellable?
    
    private let cache:   FileCacheable
    private let fetcher: NYTimesAPIFetchable
    private let decoder: JSONDecoder
    
    init(
        cache: FileCacheable = FileCache(),
        fetcher: NYTimesAPIFetchable = NYTimesAPI()
    ) {
        self.cache = cache
        self.fetcher = fetcher
        
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
    }
    
    func fetchArticlesFromCacheAndNetwork() {
        isLoading = true
        fetchArticlesFromCache()
        fetchArticlesFromNetwork()
    }
    
    func fetchArticlesFromNetwork() {
        isLoading = true
        
        cancellableGetArticles = getArticlesFormNetworkPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] newArticles in
                self?.articles = newArticles
                self?.saveArticlesToCache(newArticles)
                self?.isLoading = false
            })
    }
    
    private func fetchArticlesFromCache() {
        isLoading = true

        let articlesDirectoryURL = cache.directoryURL
            .appendingPathComponent(CachePath.articles.rawValue)
            .appendingPathComponent(method.rawValue)
            .appendingPathComponent(period.rawValue)
            .appendingPathComponent(CachePath.articles.rawValue)
        
        getArticlesFromCachePublisher(from: articlesDirectoryURL)
            .subscribe(on: cachedArticlesQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: &$articles)
    }
    
    private func getArticlesFromCachePublisher(from directory: URL) -> AnyPublisher<[Article], Never> {
        var cachedArticles: [Article] = []
        
        if let data = cache.get(from: directory),
           let decodedArticles = try? decoder.decode([Article].self, from: data) {
            
            cachedArticles = decodedArticles
        }
        
        return Just(cachedArticles)
            .eraseToAnyPublisher()
    }
    
    private func getArticlesFormNetworkPublisher() -> AnyPublisher<[Article], NetworkError> {
        fetcher.fetch(method: method, period: period)
            .decode(type: News.self, decoder: decoder)
            .mapError(NetworkError.handleError)
            .map(\.results)
            .eraseToAnyPublisher()
    }

    private func saveArticlesToCache(_ articles: [Article]) {
        let articlesDirectoryURL = cache.directoryURL
            .appendingPathComponent(CachePath.articles.rawValue)
            .appendingPathComponent(method.rawValue)
            .appendingPathComponent(period.rawValue)
        
        let encoder = JSONEncoder()
        
        if !cache.fileExists(atPath: articlesDirectoryURL.path) {
            cache.createDirectory(atPath: articlesDirectoryURL.path)
        }
        
        let articlesPathURL = articlesDirectoryURL
            .appendingPathComponent(CachePath.articles.rawValue)
        
        guard let data = try? encoder.encode(articles) else { return }
        
        cache.save(data, to: articlesPathURL)
    }
}

enum AppStorageKeys: String {
    case method
    case period
}
