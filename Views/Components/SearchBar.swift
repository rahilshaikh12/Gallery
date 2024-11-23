import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSubmit: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search artworks...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .background(Color.white.opacity(0.9))
                .cornerRadius(8)
            
            Button(action: onSubmit) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
    }
}
