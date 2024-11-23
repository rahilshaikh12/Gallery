import Foundation

struct Artwork: Identifiable, Codable {
    let id: Int
    let title: String
    let artist_display: String
    let date_display: String?  // Made optional
    let image_id: String?
    let thumbnail: Thumbnail?
    let artwork_type_title: String?  // Made optional
    let department_title: String?    // Made optional
    let artist_title: String?        // Made optional
    
    struct Thumbnail: Codable {
        let alt_text: String?
        let width: Int?
        let height: Int?
    }
}

struct ArtworkResponse: Codable {
    let data: [Artwork]
    let pagination: Pagination?
    let config: Config?  // Added config property

    struct Pagination: Codable {
        let total: Int
        let limit: Int
        let offset: Int
        let total_pages: Int
        let current_page: Int
    }

    struct Config: Codable {
        let iiif_url: String?  // URL for fetching images
    }
}

