
import Foundation

final class BreedDetailDIContainer {
    
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
    
    private func makeBreedDetailViewModel(breed: Breed) -> BreedDetailViewModel {
        return BreedDetailViewModel(breed: breed, breedsRepository: makeBreedsRepository())
    }
    
    // MARK: - ViewController
    
    func makeBreedDetailViewController(_ coordinator: AppCoordinator, breed: Breed) -> BreedDetailViewController {
        let viewModel = makeBreedDetailViewModel(breed: breed)
        let viewController = BreedDetailViewController(coordinator, viewModel: viewModel)
        return viewController
    }
}
