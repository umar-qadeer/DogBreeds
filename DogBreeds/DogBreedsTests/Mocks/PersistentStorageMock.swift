
import XCTest
@testable import DogBreeds

class PersistentStorageMock: PersistentStorage {
    
    func fetchFavouriteBreedImages(by name: String?, completion: @escaping (Result<[FavouriteBreedImage]?, Error>) -> Void) {
        completion(.failure(NSError.createError(code: 500, message: "Out of testing scope")))
    }
    
    func markFavouriteBreedImage(isFavourite: Bool, favouriteBreedImage: FavouriteBreedImage, completion: @escaping (Error?) -> Void) {
        completion(NSError.createError(code: 500, message: "Out of testing scope"))
    }
}
