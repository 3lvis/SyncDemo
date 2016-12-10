import UIKit
import Sync

class ItemsController: UITableViewController {
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
        self.tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.cellIdentifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(refresh))

        self.users = self.fetcher.fetchLocalUsers()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.cellIdentifier, for: indexPath) as! ItemCell
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name

        return cell
    }

    func refresh() {
        self.fetcher.users { error in
            if let _ = error {
                // handle error
            } else {
                self.users = self.fetcher.fetchLocalUsers()
                self.tableView.reloadData()
            }
        }
    }
}
