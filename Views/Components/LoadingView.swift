import SwiftUI

// View displayed while artworks are being loaded
struct LoadingView: View {
    var body: some View {
        VStack {
            // Circular progress indicator
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            
            // Loading message
            Text("Loading artworks...")
                .foregroundColor(.white)
                .padding(.top)
        } // end of VStack
    } // end of body
} // end of LoadingView
