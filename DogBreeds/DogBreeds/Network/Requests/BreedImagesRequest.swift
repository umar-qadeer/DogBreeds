
import Foundation

struct BreedImagesRequest: DataRequest {
    
    var name: String

    var url: String {
        let baseURL: String = NetworkRoutes.baseURL
        let path: String = NetworkRoutes.EndPoints.breedImages
        return String(format: baseURL + path, name)
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [String : String] {
        return [:]
    }

    func decode(_ data: Data) throws -> [BreedDetail] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ResponseModel<[String]>.self, from: data)
        var breedDetails = [BreedDetail]()
        
        response.message.forEach { (breedImageUrl: String) in
            let breedDetail = BreedDetail(imageUrl: breedImageUrl)
            breedDetails.append(breedDetail)
        }
        
        return breedDetails
    }
}
