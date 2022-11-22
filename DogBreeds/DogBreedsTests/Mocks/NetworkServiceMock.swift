
import XCTest
@testable import DogBreeds

class NetworkServiceMock: NetworkService {
    
    func request<Request>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) where Request: DataRequest {
                
        if let breedsData = MockDataGenerator().getMockBreedsData() {
            do {
                let decodedData = try request.decode(breedsData)
                completion(.success(decodedData))
            } catch let error as NSError {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError.createError(ofType: ErrorResponse.noData)))
        }
    }
}
