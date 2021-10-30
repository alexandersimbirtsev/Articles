
import SwiftUI

struct ArticlesListCellView: View {
    let article: Article
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncCacheImageView(url: article.thumbnail)
                .frame(width: 75, height: 75)
            
            VStack(alignment: .leading) {
                Text(article.published, style: .date)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Text(article.title)
                    .foregroundColor(.primary)
                    .font(.body)
                    .lineLimit(2)
                
                Text(article.author)
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            .lineLimit(1)
        }
    }
}

struct ArticlesListCell_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListCellView(article: .example1)
    }
}
