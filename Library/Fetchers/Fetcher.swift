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

    func users(completion: @escaping (_ result: VoidResult) -> ()) {
        self.networking.get("/users") { result in
            switch result {
            case .success(let response):
                let usersJSON = response.arrayBody
                self.persistentContainer.sync(usersJSON, inEntityNamed: User.entity().name!) { error in
                    completion(.success)
                }
            case .failure(let response):
                completion(.failure(response.error))
            }
        }
    }

    func fetchLocalUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()

        return try! self.persistentContainer.viewContext.fetch(request)
    }
}

enum VoidResult {
    case success
    case failure(NSError)
}
