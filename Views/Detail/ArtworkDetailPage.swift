import SwiftUI

struct ArtworkDetailPage: View {
    let savedArtwork: SavedArtwork
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Large Image Section
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
                        }
                    }
                }
                
                // Details Section
                VStack(spacing: 24) {
                    DetailSectionView(title: "ARTWORK", content: savedArtwork.title ?? "Untitled")
                    DetailSectionView(title: "ARTIST", content: savedArtwork.artist ?? "Unknown Artist")
                    
                    if let category = savedArtwork.category, !category.isEmpty {
                        DetailSectionView(title: "CATEGORY", content: category)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
                .padding(.horizontal)
            }
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.black.opacity(0.5), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Helper View
struct DetailSectionView: View {
    let title: String
    let content: String
    
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
