
import Foundation
@testable import DogBreeds

class MockDataGenerator {
    
    // MARK: - Properties
    
    lazy var bundle: Bundle = {
        return Bundle(for: type(of: self))
    }()
    
    // MARK: - Functions
    
    func getMockBreeds() -> [Breed] {
        
        if let url = bundle.url(forResource: "sampleData", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(ResponseModel<[String: [String]]>.self, from: data)
                var breeds = [Breed]()
                
                response.message.forEach { (key: String, value: [String]) in
                    let breed = Breed(name: key, subBreed: value)
                    breeds.append(breed)
                }
                
                return breeds
            } catch {
                print(error)
            }
        }
        return []
    }
    
    func getMockBreedsData() -> Data? {
        
        if let url = bundle.url(forResource: "sampleData", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                print(error)
            }
        }
        
        return nil
    }
}
