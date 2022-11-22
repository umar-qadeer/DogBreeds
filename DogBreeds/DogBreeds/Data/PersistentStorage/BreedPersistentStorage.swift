
import Foundation
import CoreData

struct BreedPersistentStorage: PersistentStorage {
    
    // MARK: - Properties
    
    let storage: CDPersistentStorage
    
    // MARK: - Initializer
    
    init(storage: CDPersistentStorage) {
        self.storage = storage
    }
    
    // MARK: - PersistentStorage
    
    func fetchFavouriteBreedImages(by name: String?, completion: @escaping (Result<[FavouriteBreedImage]?, Error>) -> Void) {
        var predicate: NSPredicate? = nil
        
        if let breadName = name {
            predicate = NSPredicate(format: "name = %@", breadName)
        }
        
        storage.viewContext.perform {
            
            storage.fetchManagedObjects(context: storage.viewContext, managedObject: CDFavouriteBreedImage.self, predicate: predicate, completion: { result in
                
                switch result {
                case .success(let cdFavouriteBreedImages):
                    let favouriteBreedImages = cdFavouriteBreedImages?.map({ $0.convertToFavouriteBreedImage() })
                    completion(.success(favouriteBreedImages))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    func markFavouriteBreedImage(isFavourite: Bool, favouriteBreedImage: FavouriteBreedImage, completion: @escaping (Error?) -> Void) {
        if isFavourite {    // make it unfavourite
            let predicate = NSPredicate(format: "url = %@", favouriteBreedImage.url)
            
            storage.persistentContainer.performBackgroundTask { managedObjectContext in
                
                storage.fetchManagedObjects(context: managedObjectContext, managedObject: CDFavouriteBreedImage.self, predicate: predicate, completion: { result in
                    
                    switch result {
                    case .success(let cdFavouriteBreedImages):
                        if let cdFavouriteBreedImage = cdFavouriteBreedImages?.first {
                            managedObjectContext.delete(cdFavouriteBreedImage)
                        }
                        storage.saveContext(context: managedObjectContext, completion: completion)
                    case .failure(let error):
                        completion(error)
                    }
                })
            }
        } else {    // make it favourite
            storage.persistentContainer.performBackgroundTask { managedObjectContext in
                let cdFavouriteBreedImage = CDFavouriteBreedImage(context: managedObjectContext)
                cdFavouriteBreedImage.name = favouriteBreedImage.name
                cdFavouriteBreedImage.url = favouriteBreedImage.url
                storage.saveContext(context: managedObjectContext, completion: completion)
            }
        }
    }
}
