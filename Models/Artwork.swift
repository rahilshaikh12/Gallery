import Foundation

// Model for individual artwork data
struct Artwork: Identifiable, Codable {
    let id: Int
    let title: String
    let artist_display: String
    let date_display: String?  // Optional: Date of the artwork
    let image_id: String?      // Optional: Identifier for the image
    let thumbnail: Thumbnail?  // Optional: Thumbnail details
    let artwork_type_title: String?  // Optional: Type of artwork (e.g., Painting)
    let department_title: String?    // Optional: Department or collection name
    let artist_title: String?        // Optional: Main artist name

    // Thumbnail metadata for artwork images
    struct Thumbnail: Codable {
        let alt_text: String?  // Optional: Alternative text description
        let width: Int?        // Optional: Width of the thumbnail
        let height: Int?       // Optional: Height of the thumbnail
    } // end of Thumbnail
} // end of Artwork

// Response model for API data fetching
struct ArtworkResponse: Codable {
    let data: [Artwork]        // List of artworks in the response
    let pagination: Pagination?  // Optional: Pagination metadata
    let config: Config?        // Optional: Configuration metadata

    // Pagination metadata for paginated API responses
    struct Pagination: Codable {
        let total: Int         // Total number of artworks available
        let limit: Int         // Number of artworks per page
        let offset: Int        // Offset for pagination
        let total_pages: Int   // Total number of pages
        let current_page: Int  // Current page number
    } // end of Pagination

    // Configuration metadata for image handling
    struct Config: Codable {
        let iiif_url: String?  // Optional: Base URL for fetching images
    } // end of Config
} // end of ArtworkResponse
