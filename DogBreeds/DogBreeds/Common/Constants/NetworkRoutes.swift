
import Foundation

final class NetworkRoutes {
    // API base url
    class var baseURL: String  {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("BaseURL must not be empty in plist")
        }
        return baseURL
    }
    
    struct EndPoints {
        static let breeds = "breeds/list/all"
        static let breedImages = "breed/%@/images"
    }
}
