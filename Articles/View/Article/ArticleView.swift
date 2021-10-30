
import SwiftUI

struct ArticleView: View {
    let article: Article
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.largeTitle)
                
                HStack {
                    Text(article.author)
                    Spacer()
                    Text(article.published, style: .date)
                }
                .foregroundColor(.secondary)
                
                AsyncCacheImageView(url: article.image)
                
                Text(article.subtitle)
                    .font(.title3)
                
            }
            .padding(.horizontal)
            
            Link("Open on NYTimes.com", destination: article.url)
                .padding(.vertical)
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: .example1)
    }
}
