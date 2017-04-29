import UIKit
import Sync

class UsersController: UITableViewController {
    var apiClient: APIClient
    var users = [User]()

    init(style: UITableViewStyle = .plain, apiClient: APIClient) {
        self.apiClient = apiClient

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.identifier)

        self.users = self.apiClient.fetchLocalUsers()
        self.refresh()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as! TableCell
        cell.title = self.users[indexPath.row].name

        return cell
    }

    func refresh() {
        self.apiClient.users { result in
            switch result {
            case .success:
                self.users = self.apiClient.fetchLocalUsers()
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)

        let albumsController = AlbumsController(apiClient: self.apiClient, user: user)
        albumsController.tabBarItem = UITabBarItem(title: "Albums", image: UIImage(named: "albums"), selectedImage: nil)

        let postsController = PostsController(user: user)
        postsController.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(named: "posts"), selectedImage: nil)

        let profileController = ProfileController(user: user)
        profileController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: nil)

        tabBarController.setViewControllers([albumsController, postsController, profileController], animated: true)

        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}
