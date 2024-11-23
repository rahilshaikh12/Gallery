import SwiftUI

// Main tab view containing the Gallery and Saved Artworks tabs
struct MainTabView: View {
    let persistenceController: PersistenceController // Core Data persistence controller
    @StateObject private var viewModel: ArtworkViewModel // Artwork ViewModel for managing data

    // Initialize MainTabView with a persistence controller
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        self._viewModel = StateObject(wrappedValue: ArtworkViewModel(persistenceController: persistenceController))
    } // end of init

    var body: some View {
        TabView {
            // Gallery tab for browsing artworks
            GalleryView(persistenceController: persistenceController)
                .environmentObject(viewModel)
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }

            // Saved artworks tab for viewing saved items
            SavedArtworksView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
        } // end of TabView
        .background(
            // Background image for the tab view
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            // Customize the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().unselectedItemTintColor = .white.withAlphaComponent(0.6)
            UITabBar.appearance().tintColor = .white
        } // end of onAppear
    } // end of body
} // end of MainTabView
