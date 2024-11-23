import SwiftUI

@main
struct galleryApp: App {
    @StateObject private var persistenceController = PersistenceController()
    
    init() {
        printFontFamilyNames()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(persistenceController: persistenceController)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    func printFontFamilyNames() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}
