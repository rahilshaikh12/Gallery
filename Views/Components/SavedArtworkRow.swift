import SwiftUI

// Row view displaying a single saved artwork
struct SavedArtworkRow: View {
    let artwork: SavedArtwork // Saved artwork to display in the row

    var body: some View {
        HStack {
            // Display artwork image or a placeholder
            if let imageURLString = artwork.imageURL,
               let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    } // end of switch
                } // end of AsyncImage
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
                Image(systemName: "photo") // Placeholder for missing image
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            } // end of image handling
            
            // Display artwork details (title and artist)
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title ?? "Untitled")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(artwork.artist ?? "Unknown Artist")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            } // end of VStack for artwork details
            
            Spacer()
            
            // Chevron icon indicating navigation to detail view
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        } // end of HStack
        .padding(.vertical, 8)
    } // end of body
} // end of SavedArtworkRow
