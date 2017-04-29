import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?

    lazy var apiClient: APIClient = {
        let apiClient = APIClient()

        return apiClient
    }()
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }

        let navigationController = UINavigationController(rootViewController: UsersController(apiClient: self.apiClient))
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return true
    }
}
