import UIKit
import Sync

class UsersController: UITableViewController {
    var fetcher: Fetcher

    var users = [User]()

    init(style: UITableViewStyle = .plain, fetcher: Fetcher) {
        self.fetcher = fetcher

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))

        self.users = self.fetcher.fetchLocalUsers()
        self.refresh()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name

        return cell
    }

    func refresh() {
        self.fetcher.users { result in
            switch result {
            case .success:
                self.users = self.fetcher.fetchLocalUsers()
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)

        let albumsController = AlbumsController(user: user)
        albumsController.tabBarItem = UITabBarItem(title: "Albums", image: UIImage(named: "albums"), selectedImage: nil)

        let postsController = PostsController(user: user)
        postsController.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(named: "posts"), selectedImage: nil)

        let profileController = ProfileController(user: user)
        profileController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: nil)

        tabBarController.setViewControllers([albumsController, postsController, profileController], animated: true)

        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}
