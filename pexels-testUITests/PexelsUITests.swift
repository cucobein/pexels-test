//
//  pexels_testUITests.swift
//  pexels-testUITests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import XCTest

class PexelsUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func testVideoListViewDisplaysVideos() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["Search..."]
        searchField.tap()
        searchField.typeText("nature")

        let videoList = app.scrollViews.otherElements["VideoList"]
        XCTAssertTrue(videoList.waitForExistence(timeout: 20.0))
        XCTAssertGreaterThan(videoList.children(matching: .any).count, 0, "The video list should display videos")
    }

    func testSearchFunctionality() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["Search..."]
        searchField.tap()
        searchField.clearText()
        searchField.typeText("animals")

        let videoList = app.scrollViews.otherElements["VideoList"]
        XCTAssertTrue(videoList.waitForExistence(timeout: 20.0))
        XCTAssertGreaterThan(videoList.children(matching: .any).count, 0, "List should display videos after searching")
    }

    func testNoVideosFound() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["Search..."]
        searchField.tap()
        searchField.clearText()
        searchField.typeText("ASDFnonexistentqueryWXYZ")

        let noVideosText = app.staticTexts["NoVideosFound"]
        XCTAssertTrue(noVideosText.waitForExistence(timeout: 10.0), "List should display empty state")
    }
}
