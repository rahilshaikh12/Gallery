import SwiftUI

// Custom search bar component for searching artworks
struct SearchBar: View {
    @Binding var text: String // Bound text for user input
    var onSubmit: () -> Void  // Callback function triggered when the search button is pressed

    var body: some View {
        HStack {
            // Text field for entering search queries
            TextField("Search artworks...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .background(Color.white.opacity(0.9))
                .cornerRadius(8)
            
            // Search button with magnifying glass icon
            Button(action: onSubmit) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(8)
            } // end of Button
        } // end of HStack
        .background(Color.black.opacity(0.5)) // Semi-transparent background for the search bar
        .cornerRadius(12)
    } // end of body
} // end of SearchBar
