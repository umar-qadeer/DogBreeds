
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String {get}
}

extension ReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UITableView {
    
    func registerCell<T: UITableViewCell>(class: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.className())
    }
    
    func dequeReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque reusable cell with identifier " + T.reuseIdentifier)
        }
        return cell
    }
}
