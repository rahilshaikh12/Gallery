import SwiftUI
import CoreData

// View displaying the list of saved artworks
struct SavedArtworksView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data context for managing data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedArtwork.title, ascending: true)],
        animation: .default)
    private var savedArtworks: FetchedResults<SavedArtwork> // Fetched results of saved artworks

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.black
                    .ignoresSafeArea()
                
                if savedArtworks.isEmpty {
                    // Display message when no saved artworks are found
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("No saved artworks")
                            .foregroundColor(.white)
                    } // end of VStack
                } else {
                    // List of saved artworks
                    List {
                        ForEach(savedArtworks, id: \.id) { artwork in
                            // Navigation link to the artwork detail page
                            NavigationLink(destination: ArtworkDetailPage(savedArtwork: artwork)) {
                                HStack {
                                    // Display artwork image or placeholder
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
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8) // Rounded corners for the image
                                    } else {
                                        Image(systemName: "photo") // Placeholder for missing image
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    } // end of image handling
                                    
                                    // Display artwork title and artist
                                    VStack(alignment: .leading) {
                                        Text(artwork.title ?? "Untitled")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(artwork.artist ?? "Unknown Artist")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                    } // end of VStack
                                    
                                    Spacer()
                                    
                                    // Chevron icon for navigation
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                } // end of HStack
                            }
                            .listRowBackground(Color.black.opacity(0.3)) // Background for each row
                        }
                        .onDelete(perform: deleteItems) // Enable row deletion
                    }
                    .listStyle(PlainListStyle()) // Style for the list
                }
            } // end of ZStack
            .navigationTitle("Saved Artworks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar) // Ensure toolbar background is visible
            .toolbarBackground(Color.clear, for: .navigationBar) // Transparent toolbar background
            .toolbarColorScheme(.dark, for: .navigationBar) // Dark toolbar color scheme
        } // end of NavigationView
    } // end of body

    // Deletes selected items from Core Data
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { savedArtworks[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting artwork: \(error)")
            }
        }
    } // end of deleteItems
} // end of SavedArtworksView
