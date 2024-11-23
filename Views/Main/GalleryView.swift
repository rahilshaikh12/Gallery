import SwiftUI

// Main gallery view displaying artworks and navigation controls
struct GalleryView: View {
    @EnvironmentObject var viewModel: ArtworkViewModel // ViewModel for managing artworks
    @State private var searchText = ""                // Current search query
    @State private var previousSearchText = ""        // Tracks the last search query

    // Initializer for GalleryView
    init(persistenceController: PersistenceController) {
    } // end of init

    var body: some View {
        NavigationView {
            ZStack {
                Spacer().frame(height: 20)
                
                // Background color overlay
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Search bar for querying artworks
                    SearchBar(text: $searchText) {
                        if !searchText.isEmpty && searchText != previousSearchText {
                            Task {
                                await viewModel.searchArtworks(query: searchText)
                                previousSearchText = searchText
                            }
                        } else if searchText.isEmpty && !previousSearchText.isEmpty {
                            Task {
                                await viewModel.loadDefaultArtworks()
                                previousSearchText = ""
                            }
                        }
                    } // end of SearchBar
                    
                    // Display loading, error, or artwork content
                    if viewModel.isLoading {
                        LoadingView()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.white)
                            .padding()
                    } else if !viewModel.filteredArtworks.isEmpty {
                        let artwork = viewModel.filteredArtworks[viewModel.currentIndex]
                        
                        // Display selected artwork details
                        ArtworkDetailView(artwork: artwork)
                        
                        // Navigation arrows for switching artworks
                        if viewModel.filteredArtworks.count > 1 {
                            HStack {
                                // Navigate to the previous artwork
                                Button(action: previousArtwork) {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                // Current artwork position
                                Text("\(viewModel.currentIndex + 1) of \(viewModel.filteredArtworks.count)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                
                                Spacer()
                                
                                // Navigate to the next artwork
                                Button(action: nextArtwork) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        } // end of HStack
                    } else {
                        // Display message when no artworks are found
                        Text("No artworks found")
                            .foregroundColor(.white)
                            .padding()
                    }
                } // end of VStack
            } // end of ZStack
            .navigationTitle("Gallery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black.opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        } // end of NavigationView
        .task {
            if viewModel.artworks.isEmpty {
                await viewModel.loadDefaultArtworks()
            }
        }
    } // end of body

    // Navigate to the next artwork in the filtered list
    private func nextArtwork() {
        viewModel.currentIndex = (viewModel.currentIndex + 1) % viewModel.filteredArtworks.count
    } // end of nextArtwork

    // Navigate to the previous artwork in the filtered list
    private func previousArtwork() {
        viewModel.currentIndex = viewModel.currentIndex == 0 ?
            viewModel.filteredArtworks.count - 1 : viewModel.currentIndex - 1
    } // end of previousArtwork
} // end of GalleryView

// Wrapper view for rendering individual artwork details
struct ArtworkDetailView: View {
    let artwork: Artwork // The artwork to display

    var body: some View {
        ArtworkView(artwork: artwork)
            .id(artwork.id) // Force refresh when artwork changes
    } // end of body
} // end of ArtworkDetailView
