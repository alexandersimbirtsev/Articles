
import SwiftUI
import Combine

protocol ImageFetchable {
    func fetch(from url: URL) -> AnyPublisher<Data, URLError>
}

final class ImageFetcher: ImageFetchable {
    func fetch(from url: URL) -> AnyPublisher<Data, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

final class AsyncCacheImageController: ObservableObject {
    @Published var uiImage: UIImage?
    
    private let url: URL?
    private(set) var state: State
    
    private var cancellable: AnyCancellable?
    private let imageFetchingQueue = DispatchQueue(label: "imageFetching")
    
    private let fetcher: ImageFetchable
    private let cache: FileCacheable
    private let imagesDirectoryURL: URL
    
    init(
        url: URL?,
        fetcher: ImageFetchable = ImageFetcher(),
        cache: FileCacheable = FileCache()
    ) {
        self.fetcher = fetcher
        self.cache   = cache
        self.url     = url
        self.state   = .none
        
        self.imagesDirectoryURL = cache.directoryURL
            .appendingPathComponent(CachePath.images.rawValue)
    }
    
    func fetch() {
        guard state == .none, let url = url else { return }
        
        let imageURL = imagesDirectoryURL
            .appendingPathComponent(url.deletingPathExtension().lastPathComponent)
        
        if let cachedData = cache.get(from: imageURL),
           let cachedUIImage = UIImage(data: cachedData){
            
            self.uiImage = cachedUIImage
            state = .success
            return
        }
        
        cancellable = fetcher.fetch(from: url)
            .subscribe(on: imageFetchingQueue)
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.state = .loading
                },
                receiveOutput: { [weak self] image in
                    guard let image = image else { return }
                    try? self?.saveUIImageToCache(image, to: imageURL)
                })
            .sink(
                receiveCompletion: { [weak self] in
                    if case .failure = $0 {
                        self?.state = .failed
                    }
                }, receiveValue: { [weak self] image in
                    self?.uiImage = image
                    self?.state = .success
                })
    }
    
    private func saveUIImageToCache(_ image: UIImage, to url: URL) throws {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if !cache.fileExists(atPath: imagesDirectoryURL.path) {
            cache.createDirectory(atPath: imagesDirectoryURL.path)
        }
        self.cache.save(data, to: url)
    }
}

extension AsyncCacheImageController {
    enum State {
        case failed, none
        case loading
        case success
    }
}
