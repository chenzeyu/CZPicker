import XCTest

final class ShowcaseUITests: XCTestCase {
    func testCancelAndDoneAndSearchPreserveIdentity() {
        let app = XCUIApplication()
        app.launch()
        let card = app.buttons["showcase.teammates"]
        XCTAssertTrue(card.waitForExistence(timeout: 10))
        card.tap()
        let amara = app.buttons["czpicker.option.amara"]
        XCTAssertTrue(amara.waitForExistence(timeout: 5))
        amara.tap()
        XCTAssertFalse(app.buttons["czpicker.option.noah"].isEnabled)
        app.buttons["czpicker.cancel"].tap()
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        XCTAssertTrue(card.staticTexts["2 selected"].exists)
        card.tap()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("Amara")
        XCTAssertTrue(amara.waitForExistence(timeout: 5))
        amara.tap()
        app.buttons["czpicker.done"].tap()
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        XCTAssertTrue(card.staticTexts["3 selected"].exists)
    }

    func testInteractiveDismissalDiscardsDraftAndSingleSelectionCommits() {
        let app = XCUIApplication()
        app.launch()
        let card = app.buttons["showcase.teammates"]
        card.tap()
        let amara = app.buttons["czpicker.option.amara"]
        XCTAssertTrue(amara.waitForExistence(timeout: 5))
        amara.tap()
        // Pull the sheet from its navigation area, rather than scrolling its list.
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.95))
        start.press(forDuration: 0.1, thenDragTo: end)
        if !card.isHittable { start.press(forDuration: 0.1, thenDragTo: end) }
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        XCTAssertTrue(card.staticTexts["2 selected"].exists)
        app.buttons["showcase.destination"].tap()
        let lisbon = app.buttons["czpicker.option.lisbon"]
        XCTAssertTrue(lisbon.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["czpicker.done"].isHittable)
        XCTAssertLessThanOrEqual(app.buttons["czpicker.done"].frame.maxY, app.windows.firstMatch.frame.maxY)
        lisbon.tap()
        app.buttons["czpicker.done"].tap()
        XCTAssertTrue(app.buttons["showcase.destination"].staticTexts["Lisbon"].waitForExistence(timeout: 5))
    }

    // This real UI workflow also supplies the README's simulator recording.
    func testReadmeWalkthrough() {
        let app = XCUIApplication()
        app.launch()
        let team = app.buttons["showcase.teammates"]
        XCTAssertTrue(team.waitForExistence(timeout: 10))
        print("CZ_DEMO_START=\(Date().timeIntervalSince1970)")
        Thread.sleep(forTimeInterval: 1.5)
        team.tap()
        let maya = app.buttons["czpicker.option.maya"]
        XCTAssertTrue(maya.waitForExistence(timeout: 5))
        Thread.sleep(forTimeInterval: 1.5)
        maya.tap()
        app.buttons["czpicker.option.amara"].tap()
        Thread.sleep(forTimeInterval: 1)
        let search = app.searchFields.firstMatch
        search.tap()
        search.typeText("Noah")
        let noah = app.buttons["czpicker.option.noah"]
        XCTAssertTrue(noah.waitForExistence(timeout: 5))
        noah.tap()
        Thread.sleep(forTimeInterval: 1.5)
        app.buttons["czpicker.done"].tap()
        XCTAssertTrue(team.staticTexts["3 selected"].waitForExistence(timeout: 5))
        Thread.sleep(forTimeInterval: 1.5)
        app.buttons["showcase.destination"].tap()
        let lisbon = app.buttons["czpicker.option.lisbon"]
        XCTAssertTrue(lisbon.waitForExistence(timeout: 5))
        Thread.sleep(forTimeInterval: 1)
        lisbon.tap()
        Thread.sleep(forTimeInterval: 1)
        app.buttons["czpicker.done"].tap()
        XCTAssertTrue(app.buttons["showcase.destination"].staticTexts["Lisbon"].waitForExistence(timeout: 5))
        Thread.sleep(forTimeInterval: 2)
        print("CZ_DEMO_END=\(Date().timeIntervalSince1970)")
    }

    func testUIKitPresentation() {
        let app = XCUIApplication()
        app.launch()
        app.swipeUp()
        app.buttons["showcase.uikit"].tap()
        let launch = app.buttons["Choose a destination with UIKit"]
        XCTAssertTrue(launch.waitForExistence(timeout: 5))
        launch.tap()
        let kyoto = app.buttons["czpicker.option.kyoto"]
        XCTAssertTrue(kyoto.waitForExistence(timeout: 5))
        kyoto.tap()
        app.buttons["czpicker.done"].tap()
        XCTAssertTrue(launch.waitForExistence(timeout: 5))
    }
}
