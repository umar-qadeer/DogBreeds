
import Foundation

final class AppDIContainer {
    
    lazy var networkService: NetworkService = {
        return DefaultNetworkService()
    }()
    
    lazy var persistentStore: PersistentStorage = {
        let cdStorage = CDPersistentStorage()
        return BreedPersistentStorage(storage: cdStorage)
    }()
    
    func makeBreedsListDIContainer() -> BreedsListDIContainer {
        let dependencies = BreedsListDIContainer.Dependencies(networkService: networkService, persistentStorage: persistentStore)
        return BreedsListDIContainer(dependencies: dependencies)
    }
    
    func makeBreedDetailDIContainer() -> BreedDetailDIContainer {
        let dependencies = BreedDetailDIContainer.Dependencies(networkService: networkService, persistentStorage: persistentStore)
        return BreedDetailDIContainer(dependencies: dependencies)
    }
    
    func makeFavouritesListDIContainer() -> FavouritesListDIContainer {
        let dependencies = FavouritesListDIContainer.Dependencies(networkService: networkService, persistentStorage: persistentStore)
        return FavouritesListDIContainer(dependencies: dependencies)
    }
}
