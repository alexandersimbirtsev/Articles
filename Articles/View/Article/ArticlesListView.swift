
import SwiftUI

struct ArticlesListView: View {
    @StateObject private var controller = ArticlesController()
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    methodPicker
                    periodPicker
                }
                .disabled(controller.isLoading)
                .unredacted()
                .animation(nil, value: UUID())
                .listRowSeparator(.hidden)
                
                ForEach(controller.articles) { article in
                    NavigationLink {
                        ArticleView(article: article)
                    } label: {
                        ArticlesListCellView(article: article)
                    }
                    .animation(nil, value: UUID())
                }
            }
            .overlay { noArticlesView }
            .animation(.easeInOut, value: controller.isLoading)
            .redacted(reason: controller.redactedReason)
            .listStyle(.inset)
            .disableAutocorrection(true)
            .refreshable { controller.fetchArticlesFromNetwork() }
            .navigationTitle("Articles")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .errorView(error: $controller.error)
        .onAppear(perform: controller.fetchArticlesFromCacheAndNetwork)
        .sheet(isPresented: $showSettings) { settingsView }
    }
    
    var methodPicker: some View {
        Picker("Method", selection: $controller.method) {
            ForEach(NYTimesAPI.Method.allCases) { method in
                Text("Most \(method.rawValue)")
                    .tag(method)
            }
        }
        .pickerStyle(.menu)
        .roundedShape()
    }
    
    var periodPicker: some View {
        Picker("Period", selection: $controller.period) {
            ForEach(NYTimesAPI.Method.Period.allCases) { period in
                Text(period.description)
                    .tag(period)
            }
        }
        .pickerStyle(.menu)
        .roundedShape()
    }
    
    @ViewBuilder
    var noArticlesView: some View {
        Group {
            if !controller.isLoading && controller.articles.isEmpty {
                VStack {
                    Spacer()
                    Text("No articles")
                    Text(":(")
                }
                .font(.largeTitle)
            }
        }
        .animation(nil, value: UUID())
    }
    
    @ViewBuilder
    var settingsView: some View {
        NavigationView {
            SettingsView()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { showSettings.toggle() }
                    }
                }
        }
    }
}

struct RoundedShapeViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

extension View {
    func roundedShape() -> some View {
        modifier(RoundedShapeViewModifier())
    }
}

struct ArticlesListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView()
    }
}
