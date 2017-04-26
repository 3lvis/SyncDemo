import UIKit

class AlbumsController: UITableViewController {
    unowned var user: User

    init(user: User) {
        self.user = user

        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
