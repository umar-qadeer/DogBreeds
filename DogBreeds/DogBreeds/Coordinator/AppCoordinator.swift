
import UIKit

class AppCoordinator: Coordinator {
    
    enum Destination {
        case breeds
        case breedDetail(Breed)
        case favourites
    }
    
    // MARK: - Properties
    
    private(set) var navigationController: UINavigationController?
    private var appDIContainer: AppDIContainer
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - Coordinator
    
    @discardableResult func start(from destination: Destination = .breeds) -> UIViewController? {
        set(to: destination)
        return self.navigationController
    }
    
    @discardableResult func restart(from destination: Destination = .breeds) -> UIViewController? {
        set(to: destination)
        return self.navigationController
    }
    
    func set(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.setViewControllers([viewController], animated: false)
    }
    
    func push(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func present(controller viewController: UIViewController) {
        navigationController?.present(viewController, animated: true)
    }
    
    func dismiss(animated: Bool = true, completion: @escaping () -> Void = {}) {
        self.navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .breeds:
            let diContainer = appDIContainer.makeBreedsListDIContainer()
            let viewController = diContainer.makeBreedsListViewController(self)
            return viewController
            
        case .breedDetail(let breed):
            let diContainer = appDIContainer.makeBreedDetailDIContainer()
            let viewController = diContainer.makeBreedDetailViewController(self, breed: breed)
            return viewController
            
        case .favourites:
            let diContainer = appDIContainer.makeFavouritesListDIContainer()
            let viewController = diContainer.makeFavouritesListViewController(self)
            return viewController
        }
    }
}

extension AppCoordinator: BreedsListViewControllerCoordinationDelegate {
    
    func showBreedDetail(breed: Breed) {
        push(to: .breedDetail(breed))
    }
    
    func showFavourites() {
        push(to: .favourites)
    }
}

extension AppCoordinator: BreedDetailViewControllerCoordinationDelegate {
}

extension AppCoordinator: FavouritesListViewControllerCoordinationDelegate {
}
