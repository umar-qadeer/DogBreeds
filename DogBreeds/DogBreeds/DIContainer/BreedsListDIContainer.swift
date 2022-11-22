
import Foundation

final class BreedsListDIContainer {
    
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
    
    private func makeBreedsListViewModel() -> BreedsListViewModel {
        return BreedsListViewModel(breedsRepository: makeBreedsRepository())
    }
    
    // MARK: - ViewController
    
    func makeBreedsListViewController(_ coordinator: AppCoordinator) -> BreedsListViewController {
        let viewModel = makeBreedsListViewModel()
        let viewController = BreedsListViewController(coordinator, viewModel: viewModel)
        return viewController
    }
}
