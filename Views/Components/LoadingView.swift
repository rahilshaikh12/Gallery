import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            Text("Loading artworks...")
                .foregroundColor(.white)
                .padding(.top)
        }
    }
}
