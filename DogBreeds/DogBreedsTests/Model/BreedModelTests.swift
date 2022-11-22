
import XCTest
@testable import DogBreeds

class BreedModelTests: XCTestCase {
    
    func testBreedModel_whenInit_theninitializesSuccessfully_succeeds() {
        
        // Given
        let breeds = MockDataGenerator().getMockBreeds()
        
        // When
        let breed = breeds.sorted(by: { $0.name < $1.name }).first
        
        // Then
        XCTAssertNotNil(breed)
        XCTAssertEqual(breed?.name, "affenpinscher")
        XCTAssertEqual(breed?.subBreed, [])
    }
}
