
import SwiftUI

struct SettingsView: View {
    @StateObject private var controller = SettingsController()
    
    var articlesCacheTitle: String {
        controller.articlesCacheSize.isEmpty ? "0 KB" : controller.articlesCacheSize
    }
    
    var imagesCacheTitle: String {
        controller.imagesCacheSize.isEmpty ? "0 KB" : controller.imagesCacheSize
    }
    
    var body: some View {
        List {
            Section(header: Text("Cache")) {
                CacheListCellView(
                    title:       "Articles:",
                    size:        articlesCacheTitle,
                    action:      controller.deleteArticlesCache)
                
                CacheListCellView(
                    title:       "Images:",
                    size:        imagesCacheTitle,
                    action:      controller.deleteImagesCache)
                
                Button("Delete all", role: .destructive, action: controller.deleteAllCache)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
            .onAppear(perform: controller.setAllCacheSize)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background")
            .sheet(isPresented: .constant(true)) {
                SettingsView()
            }
    }
}
