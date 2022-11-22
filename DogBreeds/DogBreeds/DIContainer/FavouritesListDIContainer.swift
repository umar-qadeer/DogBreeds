
import Foundation

final class FavouritesListDIContainer {
    
    struct Dependencies {
        let networkService: NetworkService
        let persistentStorage: PersistentStorage
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    
    private func makeBreedsRepository() -> BreedsRepositoryProtocol {
        return BreedsRepository(networkService: dependencies.networkService, persistentStorage: dependencies.persistentStorage)
    }
    
    // MARK: - ViewModel
    
    private func makeFavouritesListViewModel() -> FavouritesListViewModel {
        return FavouritesListViewModel(breedsRepository: makeBreedsRepository())
    }
    
    // MARK: - ViewController
    
    func makeFavouritesListViewController(_ coordinator: AppCoordinator) -> FavouritesListViewController {
        let viewModel = makeFavouritesListViewModel()
        let viewController = FavouritesListViewController(coordinator, viewModel: viewModel)
        return viewController
    }
}
