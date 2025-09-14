//
//  CoreDataController.swift
//  MovieVerse
//
//  Created by hari krishna on 12/09/2025.
//
import CoreData

struct CoreDataController {
    let container: NSPersistentContainer

    static let shared = CoreDataController()

    @MainActor
    static let preview: CoreDataController = CoreDataController(inMemory: true)

    private init(inMemory: Bool = false) {
        let container = NSPersistentContainer(name: "MovieVerse")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { description, error in
            print(description.url)
            if let error = error {
                if inMemory {
                    fatalError("Failed to load in-memory store: \(error)")
                } else {
                    print("Failed to load persistent store: \(error). Falling back to in-memory store.")

                    let fallback = NSPersistentStoreDescription()
                    fallback.type = NSInMemoryStoreType
                    container.persistentStoreDescriptions = [fallback]

                    do {
                        try container.persistentStoreCoordinator.addPersistentStore(
                            ofType: NSInMemoryStoreType,
                            configurationName: nil,
                            at: nil,
                            options: nil
                        )
                        print("Fallback to in-memory store succeeded")
                    } catch {
                        fatalError("Unable to create in-memory Core Data store: \(error)")
                    }
                }
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }
}


extension CoreDataController {
    @MainActor
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    @MainActor
    func saveViewContext() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }

}
