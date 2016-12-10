import CoreData
import Sync

class Fetcher {
    private let persistentContainer: NSPersistentContainer

    init() {
        let modelName = "DataModel"
        self.persistentContainer = NSPersistentContainer(name: modelName)
        let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let storeURL = containerURL.appendingPathComponent("\(modelName).sqlite")
        try! self.persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    }

    func add(completion: @escaping (Void) -> ()) {
        self.persistentContainer.performBackgroundTask { backgroundContext in
            try! Sync.insertOrUpdate(["id": 3, "name": "Elvis3"], inEntityNamed: User.entity().name!, using: backgroundContext)
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func fetchLocalUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()

        return try! self.persistentContainer.viewContext.fetch(request)
    }
}
