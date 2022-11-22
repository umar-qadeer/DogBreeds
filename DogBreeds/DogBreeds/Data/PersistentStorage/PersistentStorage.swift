
import Foundation

protocol PersistentStorage {
    func fetchFavouriteBreedImages(by name: String?, completion: @escaping (Result<[FavouriteBreedImage]?, Error>) -> Void)
    func markFavouriteBreedImage(isFavourite: Bool, favouriteBreedImage: FavouriteBreedImage, completion: @escaping (Error?) -> Void)
}
