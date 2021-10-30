
import Foundation

struct TestData {
    static let imageURL = URL(string: "https://static01.nyt.com/images/2021/10/21/opinion/21bruni-newsletter-1/21bruni-newsletter-1-mediumThreeByTwo440-v2.jpg")
}

extension Article {
    static let example1 = Article.init(
        id:        100000008023147,
        url:       URL(string: "https://www.nytimes.com/2021/10/15/opinion/covid-vaccines-unvaccinated.html")!,
        published: .now,
        author:    "By Zeynep Tufekci",
        title:     "The Unvaccinated May Not Be Who You Think",
        subtitle:  "Science can find a cure for our diseases, but not for our societal ills.",
        thumbnail: Article.Media.MediaData.example1.url,
        image:     Article.Media.MediaData.example2.url
    )
}

extension Article.Media {
    static let example1 = Article.Media.init(
        mediaMetadata: [.example1, .example2]
    )
}

extension Article.Media.MediaData {
    static let example1 = Article.Media.MediaData.init(
        url: URL(string: "https://static01.nyt.com/images/2021/10/16/reader-center/15tufekci_3/15tufekci_3-thumbStandard-v2.jpg")!,
        format: "Standard Thumbnail"
    )
    
    static let example2 = Article.Media.MediaData.init(
        url: URL(string: "https://static01.nyt.com/images/2021/10/24/us/24tennessee-statues-top-sub/merlin_196717074_f3ef32a1-2442-4b63-86dd-b7f1a5a749c8-mediumThreeByTwo440.jpg")!,
        format: "mediumThreeByTwo440"
    )
}
