import UIKit

class TableCell: UITableViewCell {
    static let identifier = String(describing: UITableViewCell.self)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var title: String? {
        didSet {
            self.textLabel?.text = self.title
        }
    }
}
