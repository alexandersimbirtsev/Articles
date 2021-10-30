
@testable import Articles
import Foundation

class MockFileCache: FileCacheable {
    var directoryURL: URL = URL(string: "https://www.apple.com")!
    
    var storage: [(String, Data)] = []
    
    init(with stub: [(String, Data)] = []) {
        self.storage = stub
    }
    
    func save(_ data: Data, to path: URL) {
        storage.append((path.absoluteString, data))
    }
    
    func get(from path: URL) -> Data? {
        storage.first { $0.0 == path.absoluteString }?.1
    }
    
    func remove(at path: URL) {
        storage.removeAll { $0.0 == path.absoluteString }
    }
    
    func fileExists(atPath path: String) -> Bool {
        storage.contains { $0.0 == path }
    }
    
    func createDirectory(atPath path: String) {
        storage.append((path, path.data(using: .utf8)!))
    }
    
    func sizeDescription(of path: URL) -> String {
        storage.contains { $0.0 == path.absoluteString } ? "100 MB" : ""
    }
}
