import CoreData
import Sync
import Networking

class Fetcher {
    private let persistentContainer: NSPersistentContainer
    private let networking: Networking

    init() {
        let modelName = "DataModel"
        self.persistentContainer = NSPersistentContainer(name: modelName)
        let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let storeURL = containerURL.appendingPathComponent("\(modelName).sqlite")
        try! self.persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)

        self.networking = Networking(baseURL: "https://jsonplaceholder.typicode.com")
    }

    func users(completion: @escaping (_ error: NSError?) -> ()) {
        self.networking.GET("/users") { json, error in
            if let error = error {
                completion(error)
            } else {
                let usersJSON = json as! [[String: Any]]
                Sync.changes(usersJSON, inEntityNamed: User.entity().name!, predicate: nil, persistentContainer: self.persistentContainer, operations: [.All], completion: completion)
            }
        }
    }

    func fetchLocalUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()

        return try! self.persistentContainer.viewContext.fetch(request)
    }
}
