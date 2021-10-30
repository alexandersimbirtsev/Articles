
@testable import Articles
import Foundation
import Combine
import UIKit.UIImage

class MockImageFetcher: ImageFetchable {
    func fetch(from url: URL) -> AnyPublisher<Data, URLError> {
        let image = UIImage(systemName: "circle")!
        let data = image.jpegData(compressionQuality: 1)
        
        return Just(data!)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
