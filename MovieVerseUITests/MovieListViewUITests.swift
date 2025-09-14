//
//  MovieListViewUITests.swift
//  MovieVerseUITests
//
//  Created by hari krishna on 14/09/2025.
//

import XCTest

final class MovieListViewUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    func test_MovieListView_NavigationBarTitle() {
        let title = app.navigationBars["MovieVerse"].firstMatch
        app.launch()
        XCTAssertTrue(title.exists, "The navigation bar title 'MovieVerse' should exist")
    }

    func test_MovieListView_ShowsProgressView() {
        app.launchEnvironment["MOCK_SCENARIO"] = "success"
        app.launchEnvironment["MOCK_DELAY"] = "1.0"
        app.launch()

        // Check that progress view exists early
        let progressView = app.activityIndicators["progressView"]
        XCTAssertTrue(progressView.waitForExistence(timeout: 0.1))

        // Verify it eventually disappears (optional)
        XCTAssertTrue(progressView.waitForNonExistence(timeout: 2.0))
    }

    func test_MovieListView_ShowsMovies() {
        app.launchEnvironment["MOCK_SCENARIO"] = "success"
        app.launchEnvironment["MOCK_DELAY"] = "1.0"
        app.launch()

        // Check that progress view exists early
        let progressView = app.activityIndicators["progressView"]
        XCTAssertTrue(progressView.waitForExistence(timeout: 0.1))

        // Verify it eventually disappears
        XCTAssertTrue(progressView.waitForNonExistence(timeout: 2.0))

        let list = app.collectionViews["movieList"].firstMatch
        XCTAssertTrue(list.waitForExistence(timeout: 1.0))

        let rows = list.descendants(matching: .any).matching(identifier: "1").count

        XCTAssertEqual(rows, 1)
    }

    func test_MovieListView_ShowsError() {
        app.launchEnvironment["MOCK_SCENARIO"] = "error"
        app.launchEnvironment["MOCK_DELAY"] = "1.0"
        app.launch()

        let rows = app.staticTexts["No movies found"].firstMatch

        XCTAssertTrue(rows.exists)
    }
    
    func test_MovieListView_ToggleToFavorite_ShowsFavorites() {
        app.launchEnvironment["MOCK_SCENARIO"] = "favorites"
        app.launchEnvironment["MOCK_DELAY"] = "1.0"
        app.launch()

        let list = app.collectionViews["movieList"].firstMatch
        XCTAssertTrue(list.waitForExistence(timeout: 2.0))

        let rows0 = list.descendants(matching: .any).matching(identifier: "1").count

        XCTAssertEqual(rows0, 0)
        
        app.segmentedControls.buttons["Favorites"].firstMatch.tap()
        
        let rows1 = list.descendants(matching: .any).matching(identifier: "1").count
        
        XCTAssertEqual(rows1, 1)
    }

    func test_MovieListView_NavigateToDetail() {
        app.launchEnvironment["MOCK_SCENARIO"] = "successWithDetail"
        app.launchEnvironment["MOCK_DELAY"] = "1.0"
        app.launch()

        // Check that progress view exists early
        let progressView = app.activityIndicators["progressView"]
        XCTAssertTrue(progressView.waitForExistence(timeout: 0.1))

        // Verify it eventually disappears
        XCTAssertTrue(progressView.waitForNonExistence(timeout: 2.0))

        let list = app.collectionViews["movieList"].firstMatch
        XCTAssertTrue(list.exists)

        let rows = list.descendants(matching: .any).matching(identifier: "1")

        rows.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["About Movie"].firstMatch.waitForExistence(timeout: 1.0))
    }
}
