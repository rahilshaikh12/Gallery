import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "https://api.artic.edu/api/v1"
    
    func fetchArtworks(page: Int = 1, limit: Int = 20) async throws -> ArtworkResponse {
        let urlString = "\(baseURL)/artworks?page=\(page)&limit=\(limit)&fields=id,title,artist_display,date_display,image_id,thumbnail,artwork_type_title,department_title,artist_title"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ArtworkResponse.self, from: data)
        return response
    }
    
    func searchArtworks(query: String) async throws -> ArtworkResponse {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)/artworks/search?q=\(encodedQuery)&limit=100&fields=id,title,artist_display,date_display,image_id,thumbnail,artwork_type_title,department_title,artist_title"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ArtworkResponse.self, from: data)
        return response
    }
}
