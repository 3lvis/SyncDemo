import UIKit

class AlbumsController: UITableViewController {
    unowned var apiClient: APIClient
    unowned var user: User
    lazy var albums = [Album]()

    init(apiClient: APIClient, user: User) {
        self.apiClient = apiClient
        self.user = user

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))

        self.albums = self.apiClient.fetchLocalAlbums(for: self.user)
        self.refresh()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let album = self.albums[indexPath.row]
        cell.textLabel?.text = album.title

        return cell
    }

    func refresh() {
        self.apiClient.albums(for: self.user) { result in
            switch result {
            case .success:
                self.albums = self.apiClient.fetchLocalAlbums(for: self.user)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
