import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var viewModel: ArtworkViewModel
    @State private var searchText = ""
    @State private var previousSearchText = ""
    
    init(persistenceController: PersistenceController) {
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Spacer().frame(height: 20)
                // Background color overlay
                Color.black
                .edgesIgnoringSafeArea(.all)
                
                VStack() {
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
                    }
                    if viewModel.isLoading {
                        LoadingView()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.white)
                            .padding()
                    } else if !viewModel.filteredArtworks.isEmpty {
                        let artwork = viewModel.filteredArtworks[viewModel.currentIndex]
                        ArtworkDetailView(artwork: artwork)  // Using wrapper view here
                        
                        // Navigation arrows
                        if viewModel.filteredArtworks.count > 1 {
                            HStack {
                                Button(action: previousArtwork) {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Text("\(viewModel.currentIndex + 1) of \(viewModel.filteredArtworks.count)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                
                                Spacer()
                                
                                Button(action: nextArtwork) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        }
                    } else {
                        Text("No artworks found")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
            .navigationTitle("Gallery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black.opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .task {
            if viewModel.artworks.isEmpty {
                await viewModel.loadDefaultArtworks()
            }
        }
    }
    
    private func nextArtwork() {
        viewModel.currentIndex = (viewModel.currentIndex + 1) % viewModel.filteredArtworks.count
    }
    
    private func previousArtwork() {
        viewModel.currentIndex = viewModel.currentIndex == 0 ?
            viewModel.filteredArtworks.count - 1 : viewModel.currentIndex - 1
    }
}

// Add this wrapper view in the same file
struct ArtworkDetailView: View {
    let artwork: Artwork
    
    var body: some View {
        ArtworkView(artwork: artwork)
            .id(artwork.id) // Force refresh when artwork changes
    }
}
