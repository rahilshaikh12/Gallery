import SwiftUI

struct ContentView: View {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 40)
                // App Title
                Text("Gallery")
                    .font(.custom("PlayfairDisplay-Italic", size: 38))
                    .padding(.top, 50)
                    .foregroundColor(.white)
                
                Spacer().frame(height: 60)
                // App Description
                Text("Dive into a world of stunning artwork. Browse, explore, and experience the beauty of art like never before.")
                    .font(.custom("PlayfairDisplay-Italic", size: 20))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100)
                    .padding(.top, 10)
                    .foregroundColor(.white)
                
                // Highlights Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Curated Collections: Explore art from famous museums worldwide.")
                    Text("Personalized Filters: Find art by style, artist, or mood.")
                    Text("Favorites: Save and revisit artworks you love.")
                }
                .padding(.top, 30)
                .padding(.horizontal, 20)
                .foregroundColor(.white)
                .font(.custom("PlayfairDisplay-Regular", size: 20))
                .frame(maxWidth: UIScreen.main.bounds.width - 100)
                
                Spacer().frame(height: 60)
                
                // Get Started Button
                NavigationLink(destination: MainTabView(persistenceController: persistenceController)
                    .navigationBarBackButtonHidden(true)
                ) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
            }
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    
}
