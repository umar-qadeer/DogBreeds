
import XCTest
@testable import DogBreeds

class DogBreedsUITests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testCellCreationAndNavigation_whenBreedsAreLoaded_whenTapped_thenUserShouldBeNaviagtedToDetailScreen_succeeds() {
        
        let app = XCUIApplication()
        let tableViewsQuery = app.tables
        let breedCell = tableViewsQuery.cells[AccessibilityIdentifier.breedCellIdentifier].firstMatch
        _ = breedCell.waitForExistence(timeout: 2.0)
        
        XCTAssertNotNil(breedCell.exists)
        
        if breedCell.exists {
            breedCell.tap()
            
            let breedDetailCell = tableViewsQuery.cells[AccessibilityIdentifier.breedDetailCellIdentifier].firstMatch
            _ = breedDetailCell.waitForExistence(timeout: 2.0)
            
            XCTAssertNotNil(breedDetailCell.exists)
        }
    }
    
    func testFavouriteButton_whenTapped_thenFavouriteButtonStateChanges_succeds() {
        let app = XCUIApplication()
        let tableViewsQuery = app.tables
        let breedCell = tableViewsQuery.cells[AccessibilityIdentifier.breedCellIdentifier].firstMatch
        _ = breedCell.waitForExistence(timeout: 2.0)
        
        XCTAssertNotNil(breedCell.exists)
        
        if breedCell.exists {
            breedCell.tap()
            
            let breedDetailCell = tableViewsQuery.cells[AccessibilityIdentifier.breedDetailCellIdentifier].firstMatch
            _ = breedDetailCell.waitForExistence(timeout: 2.0)
            
            XCTAssertNotNil(breedDetailCell.exists)
            
            let favouriteButton = breedDetailCell.buttons[AccessibilityIdentifier.favouriteButtonIdentifier]
            _ = favouriteButton.waitForExistence(timeout: 2.0)
            
            if favouriteButton.isSelected {
                favouriteButton.tap()
                XCTAssertFalse(favouriteButton.isSelected)
            } else {
                favouriteButton.tap()
                XCTAssertTrue(favouriteButton.isSelected)
            }
        }
    }
}
