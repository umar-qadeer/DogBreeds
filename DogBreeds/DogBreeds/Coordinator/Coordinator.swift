
import UIKit

protocol Coordinator {
    associatedtype Destination

    @discardableResult func start(from destination: Destination) -> UIViewController?
    @discardableResult func restart(from destination: Destination) -> UIViewController?
    func set(to destination: Destination)
    func push(to destination: Destination)
    func pop()
    func present(controller viewController: UIViewController)
    func dismiss(animated: Bool, completion: @escaping () -> Void)
    func makeViewController(for destination: Destination) -> UIViewController
}
