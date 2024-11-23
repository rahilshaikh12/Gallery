import SwiftUI

struct ArtworkView: View {
    @EnvironmentObject private var viewModel: ArtworkViewModel
    let artwork: Artwork
    @State private var isSaved: Bool = false
    @State private var showSaveAnimation: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 40)
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
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TITLE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(artwork.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    // Artist
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ARTIST")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(artwork.artist_display)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }

                    // Date
                    VStack(alignment: .leading, spacing: 4) {
                        Text("DATE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(artwork.date_display ?? "Unknown Date")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    // Department
                    if let department = artwork.department_title, !department.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("DEPARTMENT")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(department)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .padding(.horizontal)

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
            }
        }
        .background(Color.black)
        .id(artwork.id)
        .onAppear {
            checkIfArtworkIsSaved()
        }
    }
    
    private func checkIfArtworkIsSaved() {
        isSaved = viewModel.isArtworkSaved(artwork)
    }
}
