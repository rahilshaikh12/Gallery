import SwiftUI

// View for displaying individual artwork details
struct ArtworkView: View {
    @EnvironmentObject private var viewModel: ArtworkViewModel // ViewModel for managing artwork data
    let artwork: Artwork // Current artwork to display
    @State private var isSaved: Bool = false // Tracks whether the artwork is saved
    @State private var showSaveAnimation: Bool = false // Controls the save button animation

    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 40)
                
                // Display the artwork image if available
                if let imageURL = viewModel.getImageURL(for: artwork) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                        case .failure(_):
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .frame(height: 300)
                        @unknown default:
                            EmptyView()
                        } // end of switch
                    } // end of AsyncImage
                } // end of if-let imageURL

                // Display artwork metadata
                VStack(alignment: .leading, spacing: 8) {
                    Text(artwork.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(artwork.artist_display)
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Text(artwork.date_display ?? "Unknown Date")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))

                    if let department = artwork.department_title, !department.isEmpty {
                        Text(department)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    } // end of if-let department
                } // end of metadata VStack
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

                // Save/Remove button with animation
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isSaved.toggle()
                        showSaveAnimation = true
                    }

                    if isSaved {
                        viewModel.saveArtwork(artwork)
                    } else {
                        viewModel.removeArtwork(artwork)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showSaveAnimation = false
                    }
                }) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isSaved ? .red : .white)
                        .scaleEffect(showSaveAnimation ? 1.3 : 1.0)
                }
                .padding(.top)
            } // end of content VStack
        } // end of ScrollView
        .background(Color.black) // Background color for the view
        .id(artwork.id) // Forces the view to refresh when artwork changes
        .onAppear {
            checkIfArtworkIsSaved()
        } // end of onAppear
    } // end of body

    // Check if the current artwork is saved
    private func checkIfArtworkIsSaved() {
        isSaved = viewModel.isArtworkSaved(artwork)
    } // end of checkIfArtworkIsSaved
} // end of ArtworkView
