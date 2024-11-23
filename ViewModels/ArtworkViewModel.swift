import SwiftUI
import CoreData

// ViewModel for managing artworks and interactions with Core Data and the API
@MainActor
class ArtworkViewModel: ObservableObject {
    @Published var artworks: [Artwork] = [] // List of artworks
    @Published var currentIndex = 0         // Index of the currently displayed artwork
    @Published var isLoading = false        // Indicates if the ViewModel is fetching data
    @Published var errorMessage: String?    // Stores any error messages
    @Published var selectedDepartment: String? // Currently selected department for filtering
    
    private var imageBaseURL: String = "https://www.artic.edu/iiif/2" // Base URL for image fetching
    private let persistenceController: PersistenceController         // Core Data persistence controller
    
    // Initialize with a persistence controller and load default artworks
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        Task {
            await loadDefaultArtworks()
        }
    } // end of init
    
    // Load a default set of famous artworks
    func loadDefaultArtworks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Attempt to fetch artworks by famous artists
            let artists = ["Van Gogh", "Monet", "Rembrandt", "Picasso"]
            var allArtworks: [Artwork] = []
            
            for artist in artists {
                let response = try await APIService.shared.searchArtworks(query: artist)
                let artworksWithImages = response.data.filter { $0.image_id != nil }
                allArtworks.append(contentsOf: artworksWithImages)
                
                // Stop fetching if enough artworks are collected
                if allArtworks.count >= 20 {
                    break
                }
            }
            
            self.artworks = allArtworks
            
            // Update imageBaseURL if available from the API response
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
        }
    } // end of loadDefaultArtworks
    
    // Filter artworks by selected department
    var filteredArtworks: [Artwork] {
        guard let department = selectedDepartment else { return artworks }
        return artworks.filter { $0.department_title == department }
    } // end of filteredArtworks
    
    // Check if an artwork is already saved in Core Data
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
    } // end of isArtworkSaved
    
    // Save an artwork to Core Data
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
                savedArtwork.date_display = artwork.date_display
                savedArtwork.artwork_type_title = artwork.artwork_type_title
                
                try context.save()
            }
        } catch {
            print("Error saving artwork: \(error)")
        }
    } // end of saveArtwork
    
    // Remove an artwork from Core Data
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
    } // end of removeArtwork
    
    // Search artworks based on a user query
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
    } // end of searchArtworks
    
    // Generate the URL for fetching an artwork image
    func getImageURL(for artwork: Artwork) -> URL? {
        guard let imageId = artwork.image_id else { return nil }
        return URL(string: "\(imageBaseURL)/\(imageId)/full/843,/0/default.jpg")
    } // end of getImageURL
} // end of ArtworkViewModel
