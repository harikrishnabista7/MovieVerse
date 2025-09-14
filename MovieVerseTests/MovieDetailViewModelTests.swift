//
//  MovieDetailViewModelTests.swift
//  MovieVerseTests
//
//  Created by hari krishna on 14/09/2025.
//

@testable import MovieVerse
import XCTest

final class MovieDetailViewModelTests: XCTestCase {
    @MainActor
    func test_VM_GetMovieDetail_ShowsDetails() async {
        let repo = MockMovieRepository(scenario: .detail(.mock(id: 1)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo)

        XCTAssertNil(viewModel.detail)
        await viewModel.getMovieDetail()
        XCTAssertEqual(viewModel.detail?.id, 1)
    }

    @MainActor
    func test_VM_GetMovieDetail_ShowsError() async {
        let repo = MockMovieRepository(
            scenario: .error(URLError(.badServerResponse)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo)

        XCTAssertNil(viewModel.error)
        await viewModel.getMovieDetail()
        XCTAssertEqual(viewModel.error, String.noDetailFound)
    }

    @MainActor
    func test_VM_NetworkWhenOffline_ShowsCheckInternetError() async {
        let connection = MockNetworkMonitor()
        connection.simulateConnectionChange(isConnected: false)

        let repo = MockMovieRepository(scenario: .error(URLError(.badServerResponse)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo, connectionMonitor: connection)

        XCTAssertNil(viewModel.error)
        await viewModel.getMovieDetail()
        XCTAssertEqual(viewModel.error, String.checkInternet)
    }

    @MainActor
    func test_VM_NetworkWhenOnline_AutomaticallyLoadsDetail() async {
        let connection = MockNetworkMonitor()
        connection.simulateConnectionChange(isConnected: false) // connection off at start

        let repo = MockMovieRepository(scenario: .detail(.mock(id: 1)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo, connectionMonitor: connection)

        XCTAssertNil(viewModel.detail)
        XCTAssertNil(viewModel.error)

        connection.simulateConnectionChange(isConnected: true)
        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(viewModel.detail?.id, 1)
    }

    @MainActor
    func test_VM_AddToFavorite_SavesToFavorites() async {
        let repo = MockMovieRepository(scenario: .detail(.mock(id: 1)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo)

        await viewModel.getMovieDetail()

        XCTAssertFalse(viewModel.isFavorite)
        viewModel.toggleFavorite()

        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertTrue(viewModel.isFavorite)
    }

    @MainActor
    func test_VM_RemoveFromFavorite_ToggleFavoriteToFalse() async {
        let repo = MockMovieRepository(scenario: .detail(.mock(id: 1)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo)

        await viewModel.getMovieDetail()
        viewModel.isFavorite = true // simulate isFavorite true

        XCTAssertTrue(viewModel.isFavorite)
        viewModel.toggleFavorite()

        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertFalse(viewModel.isFavorite)
    }
}
