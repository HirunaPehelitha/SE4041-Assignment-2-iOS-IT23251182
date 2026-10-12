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

    // MARK: - Helpers

    /// Taps a tab. iPhone shows a tab bar at the bottom; iPad (iPadOS 26) shows a floating bar at the top.
    private func openTab(_ name: String) {
        let tabBarButton = app.tabBars.buttons[name]
        if tabBarButton.exists {
            tabBarButton.tap()
        } else {
            app.buttons[name].firstMatch.tap()
        }
    }

    /// Waits (up to 3 s) for the page number to start with `prefix`, e.g. after a page-turn animation.
    private func waitForPage(_ prefix: String) -> Bool {
        let pageNumber = app.staticTexts["reader.pageNumber"]
        let predicate = NSPredicate(format: "label BEGINSWITH %@", prefix)
        return XCTWaiter.wait(for: [expectation(for: predicate, evaluatedWith: pageNumber)], timeout: 3) == .completed
    }

    // MARK: - Tests

    func testOpenBookAndTurnPage() {
        app.buttons["book.The Kite Over Galle Fort"].tap()

        let pageNumber = app.staticTexts["reader.pageNumber"]
        XCTAssertTrue(pageNumber.waitForExistence(timeout: 3))
        XCTAssertTrue(waitForPage("Page 1 of"))

        app.swipeLeft()
        XCTAssertTrue(waitForPage("Page 2 of"))
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
        openTab("Bookmarks")
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
        openTab("Profile")
        XCTAssertTrue(app.navigationBars["Profile"].waitForExistence(timeout: 3))

        let nameField = app.textFields["profile.name"]
        nameField.tap()
        nameField.typeText("Hiruna Pehelitha")

        XCTAssertTrue(app.staticTexts["HP"].exists)            // initials picture
        XCTAssertTrue(app.staticTexts["Books in library"].exists)
    }

    func testReaderWorksInLandscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
        defer { XCUIDevice.shared.orientation = .portrait }

        app.buttons["book.The Kite Over Galle Fort"].tap()
        let pageNumber = app.staticTexts["reader.pageNumber"]
        XCTAssertTrue(pageNumber.waitForExistence(timeout: 3))

        // Swipe on the page itself (the whole-app swipe isn't reliable after rotating).
        app.scrollViews["reader.page"].firstMatch.swipeLeft(velocity: .fast)
        XCTAssertTrue(waitForPage("Page 2 of"))
    }

    func testLaunchPerformance() {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
