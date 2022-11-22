
import Foundation
import CoreData

final class CDPersistentStorage {

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DogBreeds")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext = persistentContainer.viewContext
    
    // MARK: - Functions
        
    func fetchManagedObjects<T: NSManagedObject>(context: NSManagedObjectContext, managedObject: T.Type, offSet: Int = 0, page: Int = 0, predicate: NSPredicate? = nil, completion: ((Result<[T]?, Error>) -> Void)) {
        /*
         - Incase we needed pagination at this level we would have been using the request.fetchLimit and request.fetchOffSet to
         - apply pagination in coredata
         */
        do {
            let request = managedObject.fetchRequest()
            request.predicate = predicate
            let result = try context.fetch(request) as? [T]
            completion(.success(result))
        } catch {
            print(error)
            completion(.failure(error))
        }
    }
    
    func saveContext(context: NSManagedObjectContext, completion: ((Error?) -> Void)? = nil) {
        
        if context.hasChanges {
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion?(nil)
            }
        }
    }
}
