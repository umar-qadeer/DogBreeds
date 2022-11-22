
import XCTest
@testable import DogBreeds

class BreedsRepositoryTests: XCTestCase {
    
    var expectation: XCTestExpectation?
    var error: Error?
    
    override func setUpWithError() throws {
        try super.setUpWithError()

        error = nil
    }

    override func tearDownWithError() throws {
        error = nil
        expectation = nil

        try super.tearDownWithError()
    }
    
    func testFetchBreeds_whenSuccessfullyFetchBreeds_breedsArrayShouldHaveCountEqualToNinetySix_succeeds() {
        // given
        expectation = self.expectation(description: "Fetch breeds list")
        expectation?.expectedFulfillmentCount = 1
        
        let networkServiceMock = NetworkServiceMock()
        let persistentStorageMock = PersistentStorageMock()

        // when
        var breeds: [Breed]?
        let repository = BreedsRepository(networkService: networkServiceMock, persistentStorage: persistentStorageMock)
        
        repository.fetchBreeds { [weak self] result in
            switch result {
            case .success(let breedsList):
                breeds = breedsList
                self?.expectation?.fulfill()
            case .failure(let error):
                self?.error = error
                self?.expectation?.fulfill()
            }
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error, "Test Case Failed: got error on fetch breed")
        XCTAssertEqual((breeds?.count ?? 0), 96)
    }
}
