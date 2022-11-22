
import Foundation
import CoreData

extension CDFavouriteBreedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFavouriteBreedImage> {
        return NSFetchRequest<CDFavouriteBreedImage>(entityName: "CDFavouriteBreedImage")
    }

    @NSManaged public var name: String
    @NSManaged public var url: String

}

extension CDFavouriteBreedImage : Identifiable {
}
