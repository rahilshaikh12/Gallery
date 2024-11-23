import SwiftUI
import CoreData

@MainActor
class ArtworkViewModel: ObservableObject {
    @Published var artworks: [Artwork] = []
    @Published var currentIndex = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedDepartment: String?
    
    private var imageBaseURL: String = "https://www.artic.edu/iiif/2"
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        Task {
            await loadDefaultArtworks()
        }
    }
    
    func loadDefaultArtworks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Try to load famous artists' works
            let artists = ["Van Gogh", "Monet", "Rembrandt", "Picasso"]
            var allArtworks: [Artwork] = []
            
            for artist in artists {
                let response = try await APIService.shared.searchArtworks(query: artist)
                let artworksWithImages = response.data.filter { $0.image_id != nil }
                allArtworks.append(contentsOf: artworksWithImages)
                
                // If we have enough artworks, break the loop
                if allArtworks.count >= 20 {
                    break
                }
            }
            
            // Update the UI
            self.artworks = allArtworks
            if let config = try await APIService.shared.fetchArtworks(limit: 1).config,
               let iiifURL = config.iiif_url {
                self.imageBaseURL = iiifURL
            } else {
                self.imageBaseURL = "https://www.artic.edu/iiif/2" // Fallback URL
            }
            self.currentIndex = 0
            self.isLoading = false
            
            if self.artworks.isEmpty {
                self.errorMessage = "No artworks found"
            }
        } catch {
            self.errorMessage = "Failed to load artworks: \(error.localizedDescription)"
            self.isLoading = false
            print("Error details: \(error)")
        }
    }
    
    var filteredArtworks: [Artwork] {
        guard let department = selectedDepartment else { return artworks }
        return artworks.filter { $0.department_title == department }
    }
    
    func isArtworkSaved(_ artwork: Artwork) -> Bool {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<SavedArtwork> = SavedArtwork.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND artist == %@", artwork.title, artwork.artist_display)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking saved artwork: \(error)")
            return false
        }
    }
    
    func saveArtwork(_ artwork: Artwork) {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<SavedArtwork> = SavedArtwork.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND artist == %@", artwork.title, artwork.artist_display)
        
        do {
            let existingArtworks = try context.fetch(fetchRequest)
            if existingArtworks.isEmpty {
                let savedArtwork = SavedArtwork(context: context)
                savedArtwork.id = UUID()
                savedArtwork.title = artwork.title
                savedArtwork.artist = artwork.artist_display
                savedArtwork.imageURL = getImageURL(for: artwork)?.absoluteString ?? ""
                savedArtwork.category = artwork.department_title
                
                try context.save()
            }
        } catch {
            print("Error saving artwork: \(error)")
        }
    }
    
    func removeArtwork(_ artwork: Artwork) {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<SavedArtwork> = SavedArtwork.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND artist == %@", artwork.title, artwork.artist_display)
        
        do {
            let existingArtworks = try context.fetch(fetchRequest)
            for savedArtwork in existingArtworks {
                context.delete(savedArtwork)
            }
            try context.save()
        } catch {
            print("Error removing artwork: \(error)")
        }
    }
    
    func searchArtworks(query: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await APIService.shared.searchArtworks(query: query)
            self.artworks = response.data.filter { $0.image_id != nil }
            if let config = response.config, let iiifURL = config.iiif_url {
                self.imageBaseURL = iiifURL
            } else {
                self.imageBaseURL = "https://www.artic.edu/iiif/2" // Fallback URL
            }
            self.currentIndex = 0
            self.isLoading = false
            
            if self.artworks.isEmpty {
                self.errorMessage = "No artworks found for '\(query)'"
            }
        } catch {
            self.errorMessage = "Failed to search artworks: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    func getImageURL(for artwork: Artwork) -> URL? {
        guard let imageId = artwork.image_id else { return nil }
        return URL(string: "\(imageBaseURL)/\(imageId)/full/843,/0/default.jpg")
    }
}
