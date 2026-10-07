//
//  BookNestUITests.swift
//  BookNestUITests
//
//  Taps through the app like a real user would.
//

import XCTest

final class BookNestUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launchArguments = ["-uiTesting"]   // fresh database with the sample books
        app.launch()
    }

    func testOpenBookAndTurnPage() {
        app.buttons["book.The Kite Over Galle Fort"].tap()

        let pageNumber = app.staticTexts["reader.pageNumber"]
        XCTAssertTrue(pageNumber.waitForExistence(timeout: 3))
        XCTAssertTrue(pageNumber.label.hasPrefix("Page 1 of"))

        app.swipeLeft()
        XCTAssertTrue(pageNumber.label.hasPrefix("Page 2 of"))
    }

    func testContinueReadingCardAppearsAfterOpeningBook() {
        XCTAssertFalse(app.buttons["continueReading"].exists)   // nothing read yet

        app.buttons["book.The Kite Over Galle Fort"].tap()
        app.swipeLeft()                                          // go to page 2
        app.navigationBars.buttons.element(boundBy: 0).tap()     // back to Library

        XCTAssertTrue(app.buttons["continueReading"].waitForExistence(timeout: 3))
    }

    func testBookmarkShowsInBookmarksTab() {
        app.buttons["book.The Kite Over Galle Fort"].tap()
        app.buttons["reader.bookmark"].tap()

        // The tab bar is hidden while reading, so go back to the library first.
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tabBars.buttons["Bookmarks"].tap()
        XCTAssertTrue(app.staticTexts["The Kite Over Galle Fort"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Page 1"].exists)
    }

    func testAddBook() {
        app.navigationBars["Library"].buttons["Add Book"].tap()

        app.textFields["add.title"].tap()
        app.textFields["add.title"].typeText("My Test Book")
        app.textViews["add.text"].tap()
        app.textViews["add.text"].typeText("Hello from the UI test.")
        app.buttons["add.save"].tap()

        XCTAssertTrue(app.buttons["book.My Test Book"].waitForExistence(timeout: 3))
    }

    func testProfileShowsNameAndStats() {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3))

        let nameField = app.textFields["profile.name"]
        nameField.tap()
        nameField.typeText("Hiruna Pehelitha")

        XCTAssertTrue(app.staticTexts["HP"].exists)            // initials picture
        XCTAssertTrue(app.staticTexts["Books in library"].exists)
    }

    func testLaunchPerformance() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
