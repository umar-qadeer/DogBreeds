
import XCTest
@testable import DogBreeds

class BreedsRepositoryMock: BreedsRepositoryProtocol {
    func fetchBreeds(completion: @escaping (Result<[Breed], Error>) -> Void) {
        let breeds = MockDataGenerator().getMockBreeds()
        let result: Result<[Breed], Error> = .success(breeds)
        completion(result)
    }
    
    func fetchBreedImages(by name: String, completion: @escaping (Result<[BreedDetail], Error>) -> Void) {
        let result: Result<[BreedDetail], Error> = .failure(NSError.createError(code: 500, message: "Out of testing scope"))
        completion(result)
    }
    
    func fetchFavouriteBreedImages(by name: String?, completion: @escaping (Result<[FavouriteBreedImage]?, Error>) -> Void) {
        let result: Result<[FavouriteBreedImage]?, Error> = .failure(NSError.createError(code: 500, message: "Out of testing scope"))
        completion(result)
    }
    
    func markFavouriteBreedImage(isFavourite: Bool, favouriteBreedImage: FavouriteBreedImage, completion: @escaping (Error?) -> Void) {
        let error = NSError.createError(code: 500, message: "Out of testing scope")
        completion(error)
    }
}
