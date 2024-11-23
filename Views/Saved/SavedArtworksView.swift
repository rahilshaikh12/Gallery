import SwiftUI
import CoreData

struct SavedArtworksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedArtwork.title, ascending: true)],
        animation: .default)
    private var savedArtworks: FetchedResults<SavedArtwork>
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                
                if savedArtworks.isEmpty {
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("No saved artworks")
                            .foregroundColor(.white)
                    }
                } else {
                    List {
                        ForEach(savedArtworks, id: \.id) { artwork in
                            NavigationLink(destination: ArtworkDetailPage(savedArtwork: artwork)) {
                                HStack {
                                    // Fixed the optional string handling
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
                                            }
                                        }
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)  // Added corner radius to images
                                    } else {
                                        Image(systemName: "photo")
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(artwork.title ?? "Untitled")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(artwork.artist ?? "Unknown Artist")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                            }
                            .listRowBackground(Color.black.opacity(0.3))
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Saved Artworks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { savedArtworks[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting artwork: \(error)")
            }
        }
    }
}
