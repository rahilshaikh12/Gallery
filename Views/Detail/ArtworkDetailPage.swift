import SwiftUI

// View displaying detailed information about a saved artwork
struct ArtworkDetailPage: View {
    let savedArtwork: SavedArtwork // The saved artwork to display

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image Section
                if let imageURLString = savedArtwork.imageURL,
                   let imageURL = URL(string: imageURLString) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 400)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .frame(height: 400)
                        case .failure:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity)
                                .frame(height: 400)
                        @unknown default:
                            EmptyView()
                        } // end of switch
                    } // end of AsyncImage
                } // end of if-let imageURL

                // Details Section
                VStack(spacing: 24) {
                    DetailSectionView(title: "ARTWORK", content: savedArtwork.title ?? "Untitled")
                    DetailSectionView(title: "ARTIST", content: savedArtwork.artist ?? "Unknown Artist")
                    
                    if let date = savedArtwork.date_display {
                        DetailSectionView(title: "DATE", content: date)
                    }
                    
                    if let category = savedArtwork.category, !category.isEmpty {
                        DetailSectionView(title: "CATEGORY", content: category)
                    }
                    
                    if let artworkType = savedArtwork.artwork_type_title {
                        DetailSectionView(title: "TYPE", content: artworkType)
                    }
                } // end of Details Section
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
                .padding(.horizontal)
            } // end of VStack
        } // end of ScrollView
        .background(Color.black) // Background for the entire page
        .navigationBarTitleDisplayMode(.inline) // Inline navigation bar title
        .toolbarBackground(.visible, for: .navigationBar) // Ensure navigation bar background is visible
        .toolbarBackground(Color.black.opacity(0.5), for: .navigationBar) // Semi-transparent black toolbar background
        .toolbarColorScheme(.dark, for: .navigationBar) // Dark color scheme for the toolbar
    } // end of body
} // end of ArtworkDetailPage

// MARK: - Helper View

// Helper view for displaying individual detail sections
struct DetailSectionView: View {
    let title: String // Section title
    let content: String // Section content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text(content)
                .font(.body)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        } // end of VStack
        .frame(maxWidth: .infinity, alignment: .leading)
    } // end of body
} // end of DetailSectionView
