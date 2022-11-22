
import Foundation
import CoreData

@objc(CDFavouriteBreedImage)
public class CDFavouriteBreedImage: NSManagedObject {
    
    func convertToFavouriteBreedImage() -> FavouriteBreedImage {
        return FavouriteBreedImage(name: self.name, url: self.url)
    }
}
