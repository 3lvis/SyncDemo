import CoreData
import Sync
import Networking

enum VoidResult {
    case success
    case failure(NSError)
}

class APIClient {
    fileprivate let persistentContainer: NSPersistentContainer
    fileprivate let networking: Networking

    init() {
        let modelName = "DataModel"
        self.persistentContainer = NSPersistentContainer(name: modelName)
        let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let storeURL = containerURL.appendingPathComponent("\(modelName).sqlite")
        try! self.persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)

        self.networking = Networking(baseURL: "https://jsonplaceholder.typicode.com")
    }
}

extension APIClient {
    func users(completion: @escaping (_ result: VoidResult) -> ()) {
        self.networking.get("/users") { result in
            switch result {
            case .success(let response):
                let objectsJSON = response.arrayBody
                self.persistentContainer.sync(objectsJSON, inEntityNamed: User.entity().name!) { error in
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

extension APIClient {
    func albumPredicate(for user: User) -> NSPredicate {
        return NSPredicate(format: "%K = %@", User.entity().name!.lowercased(), user)
    }

    func albums(for user: User, completion: @escaping (_ result: VoidResult) -> ()) {
        self.networking.get("/albums") { result in
            switch result {
            case .success(let response):
                let objectsJSON = response.arrayBody
                self.persistentContainer.sync(objectsJSON, inEntityNamed: Album.entity().name!, predicate: self.albumPredicate(for: user)) { error in
                    completion(.success)
                }
            case .failure(let response):
                completion(.failure(response.error))
            }
        }
    }

    func fetchLocalAlbums(for user: User) -> [Album] {
        let request: NSFetchRequest<Album> = Album.fetchRequest()
        request.predicate = albumPredicate(for: user)

        return try! self.persistentContainer.viewContext.fetch(request)
    }
}
