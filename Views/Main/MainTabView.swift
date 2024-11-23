import SwiftUI

struct MainTabView: View {
    let persistenceController: PersistenceController
    @StateObject private var viewModel: ArtworkViewModel
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        self._viewModel = StateObject(wrappedValue: ArtworkViewModel(persistenceController: persistenceController))
    }
    
    var body: some View {
        TabView {
            GalleryView(persistenceController: persistenceController)
                .environmentObject(viewModel)
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
            
            SavedArtworksView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
        }
        .background(
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().unselectedItemTintColor = .white.withAlphaComponent(0.6)
            UITabBar.appearance().tintColor = .white
        }
    }
}
