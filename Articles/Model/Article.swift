
import Foundation

struct News: Codable {
    let results: [Article]
}

struct Article: Identifiable {
    let id:        Int
    let url:       URL
    let published: Date
    let author:    String
    let title:     String
    let subtitle:  String
    var thumbnail: URL?
    var image:     URL?
}

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}

extension Article: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case published = "publishedDate"
        case author = "byline"
        case title
        case subtitle = "abstract"
        case thumbnail
        case image
        case media
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id       = try container.decode(Int.self,    forKey: .id)
        url      = try container.decode(URL.self,    forKey: .url)
        author   = try container.decode(String.self, forKey: .author)
        title    = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        
        do {
            thumbnail = try container.decodeIfPresent(URL.self, forKey: .thumbnail)
            image     = try container.decodeIfPresent(URL.self, forKey: .image)
            published = try container.decode(Date.self, forKey: .published)
        } catch {
            let media = try container.decode([Media].self, forKey: .media)

            thumbnail = media.first?.mediaMetadata.filter {
                $0.format == Article.Media.MediaData.Format.thumbnail.rawValue
            }.first?.url

            image = media.first?.mediaMetadata.filter {
                $0.format == Article.Media.MediaData.Format.image.rawValue
            }.first?.url
            
            let publishedString = try container.decode(String.self, forKey: .published)
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            published = dateFormatterGet.date(from: publishedString) ?? .now
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id,        forKey: .id)
        try container.encode(url,       forKey: .url)
        try container.encode(published, forKey: .published)
        try container.encode(author,    forKey: .author)
        try container.encode(title,     forKey: .title)
        try container.encode(subtitle,  forKey: .subtitle)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(image,     forKey: .image)
    }
}

extension Article {
    struct Media: Codable {
        let mediaMetadata: [MediaData]
        
        enum CodingKeys: String, CodingKey {
            case mediaMetadata = "media-metadata"
        }
    }
}

extension Article.Media {
    struct MediaData: Codable {
        let url: URL
        let format: String
        
        enum Format: String {
            case thumbnail = "Standard Thumbnail"
            case image = "mediumThreeByTwo440"
        }
    }
}
