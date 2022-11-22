
import XCTest
@testable import DogBreeds

class BreedsListViewModelTests: XCTestCase, BreedsListViewModelToViewDelegate {
    
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
    
    func testWhenFetchBreedsRecieveBreeds_thenViewModelBreedsCountIsEqualToNinetySix_succeeds() {
        // given
        expectation = expectation(description: "Fetch breeds list")
        expectation?.expectedFulfillmentCount = 1
        
        let breedsRepositoryMock = BreedsRepositoryMock()
        let viewModel = BreedsListViewModel(breedsRepository: breedsRepositoryMock)
        viewModel.delegate = self
        
        // when
        viewModel.fetchBreeds()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(error, "Test Case Failed: got error on fetch breed")
        XCTAssertEqual((viewModel.breeds?.count ?? 0), 96)
    }
    
    // MARK: - BreedsListViewModelToViewDelegate
    
    func updateUI() {
        expectation?.fulfill()
    }
    
    func showError(error: Error) {
        self.error = error
        expectation?.fulfill()
    }
    
    func showLoading(_ loading: Bool) {
        // no need to test, it's specific to UI
    }
}
