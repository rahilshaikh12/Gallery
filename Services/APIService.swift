import Foundation

// Service for interacting with the Art Institute of Chicago API
class APIService {
    static let shared = APIService() // Singleton instance of the service
    private let baseURL = "https://api.artic.edu/api/v1" // Base URL for the API

    // Fetch a paginated list of artworks
    func fetchArtworks(page: Int = 1, limit: Int = 20) async throws -> ArtworkResponse {
        // Construct the URL for fetching artworks with specified page and limit
        let urlString = "\(baseURL)/artworks?page=\(page)&limit=\(limit)&fields=id,title,artist_display,date_display,image_id,thumbnail,artwork_type_title,department_title,artist_title"
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Perform the API request
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the response into the ArtworkResponse model
        let response = try JSONDecoder().decode(ArtworkResponse.self, from: data)
        return response
    } // end of fetchArtworks
    
    // Search for artworks using a query string
    func searchArtworks(query: String) async throws -> ArtworkResponse {
        // Encode the query to make it safe for use in a URL
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        // Construct the URL for searching artworks
        let urlString = "\(baseURL)/artworks/search?q=\(encodedQuery)&limit=100&fields=id,title,artist_display,date_display,image_id,thumbnail,artwork_type_title,department_title,artist_title"
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Perform the API request
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the response into the ArtworkResponse model
        let response = try JSONDecoder().decode(ArtworkResponse.self, from: data)
        return response
    } // end of searchArtworks
} // end of APIService
