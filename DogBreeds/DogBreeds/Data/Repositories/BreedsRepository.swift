
import Foundation

protocol BreedsRepositoryProtocol: AnyObject {
    func fetchBreeds(completion: @escaping (Result<[Breed], Error>) -> Void)
    func fetchBreedImages(by name: String, completion: @escaping (Result<[BreedDetail], Error>) -> Void)
    func fetchFavouriteBreedImages(by name: String?, completion: @escaping (Result<[FavouriteBreedImage]?, Error>) -> Void)
    func markFavouriteBreedImage(isFavourite: Bool, favouriteBreedImage: FavouriteBreedImage, completion: @escaping (Error?) -> Void)
}

final class BreedsRepository: BreedsRepositoryProtocol {
    
    // MARK: - Variables
    
    private let networkService: NetworkService
    private let storage: PersistentStorage
    
    // MARK: - Init
    
    init(networkService: NetworkService, persistentStorage: PersistentStorage) {
        self.networkService = networkService
        self.storage = persistentStorage
    }
    
    // MARK: - BreedsRepositoryProtocol
    
    func fetchBreeds(completion: @escaping (Result<[Breed], Error>) -> Void) {
        networkService.request(BreedsRequest(), completion: completion)
    }
    
    func fetchBreedImages(by name: String, completion: @escaping (Result<[BreedDetail], Error>) -> Void) {
        networkService.request(BreedImagesRequest(name: name), completion: completion)
    }
    
    func fetchFavouriteBreedImages(by name: String?, completion: @escaping (Result<[FavouriteBreedImage]?, Error>) -> Void) {
        storage.fetchFavouriteBreedImages(by: name, completion: completion)
    }
    
    func markFavouriteBreedImage(isFavourite: Bool, favouriteBreedImage: FavouriteBreedImage, completion: @escaping (Error?) -> Void) {
        storage.markFavouriteBreedImage(isFavourite: isFavourite, favouriteBreedImage: favouriteBreedImage, completion: completion)
    }
}
