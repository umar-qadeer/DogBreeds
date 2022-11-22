
import Foundation

struct BreedsRequest: DataRequest {

    var url: String {
        let baseURL: String = NetworkRoutes.baseURL
        let path: String = NetworkRoutes.EndPoints.breeds
        return baseURL + path
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [String : String] {
        return [:]
    }

    func decode(_ data: Data) throws -> [Breed] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ResponseModel<[String: [String]]>.self, from: data)
        var breeds = [Breed]()
        
        response.message.forEach { (key: String, value: [String]) in
            let breed = Breed(name: key, subBreed: value)
            breeds.append(breed)
        }
        
        breeds.sort { $0.name < $1.name }
        
        return breeds
    }
}
