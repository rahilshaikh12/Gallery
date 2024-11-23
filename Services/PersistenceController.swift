import CoreData
import SwiftUI

// PersistenceController manages the Core Data stack for the app
class PersistenceController: ObservableObject {
    static let shared = PersistenceController() // Singleton instance for global access

    let container: NSPersistentContainer // Core Data container for managing the database

    // Initialize the Core Data stack
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "gallery") // Name of the Core Data model
        
        // Set up an in-memory store for testing or preview
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Load the persistent stores
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Configure the context to handle merges and conflicts
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    } // end of init

    // Static preview instance for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        return controller
    }() // end of preview

    // Save changes in the context to the persistent store
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    } // end of save
} // end of PersistenceController
