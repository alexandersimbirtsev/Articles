
import SwiftUI

struct AsyncCacheImageView: View {
    @StateObject private var controller: AsyncCacheImageController
    
    init(url: URL?) {
        self._controller = .init(wrappedValue: AsyncCacheImageController(url: url))
    }
    
    var body: some View {
        Group {
            switch controller.state {
            case .failed, .none: NoImageView()
            case .loading: ProgressView()
            case .success: successImageView
            }
        }
        .onAppear(perform: controller.fetch)
    }
    
    @ViewBuilder
    var successImageView: some View {
        if let uiImage = controller.uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            NoImageView()
        }
    }
}

struct AsyncCacheImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncCacheImageView(url: TestData.imageURL)
    }
}
