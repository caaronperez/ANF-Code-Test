//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//

import XCTest
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {

    var testInstance: ANFExploreCardTableViewController!
    
    override func setUp() {
        super.setUp()
        testInstance = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? ANFExploreCardTableViewController
        // With dependency injection:
        // testInstance.exploreService = MockANFExploreService()
        
        // With test data from JSON (best use case for this one)
        if let testData = loadTestData() {
            testInstance.exploreData = testData
        } else {
            XCTFail("Failed to load test data")
        }

        testInstance.loadViewIfNeeded()
    }

    func test_numberOfSections_ShouldBeOne() {
        let numberOfSections = testInstance.numberOfSections(in: testInstance.tableView)
        XCTAssertEqual(numberOfSections, 1, "Table view should have 1 section")
    }
    
    func test_numberOfRows_ShouldBeCorrect() {
        let numberOfRows = testInstance.tableView(testInstance.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, testInstance.exploreData.count, "Table view row count should match exploreData count")
    }
    
    func test_backgroundImage_ShouldAdjustSize() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let imageView = firstCell.viewWithTag(2) as? UIImageView
        
        XCTAssertNotNil(imageView, "Image view should not be nil")
        
        // Simulate setting an image and test dynamic height adjustment
        if let image = UIImage(named: "test_image") {
            imageView?.image = image
            let aspectRatio = image.size.height / image.size.width
            let expectedHeight = imageView?.superview?.frame.width ?? 0 * aspectRatio
            
            if let heightConstraint = imageView?.constraints.first(where: { $0.firstAttribute == .height }) {
                XCTAssertEqual(heightConstraint.constant, expectedHeight, "Image view height should match calculated aspect ratio")
            } else {
                XCTFail("Height constraint for the image view is missing")
            }
        }
    }
    
    func test_topDescription_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let label = firstCell.viewWithTag(3) as? UILabel
        
        XCTAssertNotNil(label, "Top description label should not be nil")
        XCTAssertEqual(label?.font.pointSize, 13, "Top description font size should be 13")
    }

    func test_title_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let titleLabel = firstCell.viewWithTag(1) as? UILabel
        
        XCTAssertNotNil(titleLabel, "Title label should not be nil")
        XCTAssertEqual(titleLabel?.font.pointSize, 17, "Title font size should be 17")
        let fontTraits = titleLabel?.font.fontDescriptor.symbolicTraits
        let isBold = fontTraits?.contains(.traitBold) ?? false
        XCTAssertTrue(isBold, "Title font should be bold")
    }

    func test_promoMessage_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let promoLabel = firstCell.viewWithTag(4) as? UILabel
        
        XCTAssertNotNil(promoLabel, "Promo message label should not be nil")
        XCTAssertEqual(promoLabel?.font.pointSize, 11, "Promo message font size should be 11")
    }

    func test_bottomDescription_FontSize_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let bottomDescriptionLabel = firstCell.viewWithTag(5) as? UILabel
        
        XCTAssertNotNil(bottomDescriptionLabel, "Bottom description label should not be nil")
        XCTAssertEqual(bottomDescriptionLabel?.font.pointSize, 13, "Bottom description font size should be 13")
    }

    func test_contentButtons_FontSizeAndTargets_ShouldBeCorrect() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let buttonContainer = firstCell.viewWithTag(6) as? UIStackView
        
        XCTAssertNotNil(buttonContainer, "Button container should not be nil")
        
        let buttons = buttonContainer?.arrangedSubviews.compactMap { $0 as? UIButton }
        XCTAssertEqual(buttons?.count, testInstance.exploreData[0].content?.count ?? 0, "Number of buttons should match content items")
        
        buttons?.enumerated().forEach { index, button in
            XCTAssertEqual(button.titleLabel?.font.pointSize, 15, "Button font size should be 15")
            XCTAssertEqual(button.restorationIdentifier, testInstance.exploreData[0].content?[index].target, "Button target should match content target")
        }
    }
}
