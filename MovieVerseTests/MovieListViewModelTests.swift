//
//  MovieListViewModelTests.swift
//  MovieVerseTests
//
//  Created by hari krishna on 11/09/2025.
//

@testable import MovieVerse
import XCTest

final class MovieListViewModelTests: XCTestCase {
    @MainActor
    func test_VM_LoadMovie_ShowsLatestResult() async {
        let viewModel = makeSut(scenario: .movies(movies))
        await viewModel.loadMovies()
        XCTAssertEqual(viewModel.movies.count, 1)
    }

    @MainActor
    func test_VM_LoadMovie_GeneratesError() async {
        let viewModel = makeSut(scenario: errorScenario)

        await viewModel.loadMovies()
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertNotNil(viewModel.error)
    }

    @MainActor
    func test_VM_SearchMovie_ReturnsMoviesMatchingSearchText() async {
        let viewModel = makeSut(scenario: .movies([
            Movie.mock(id: 1, title: "Shuttle Island"),
            Movie.mock(id: 2, title: "Inception"),
        ]))
        let searchExpectation = expectation(description: "Search expectation")

        let cancellable = viewModel.$movies.sink { movies in
            if movies.count == 1 && movies.first?.title.contains("Shuttle") == true {
                searchExpectation.fulfill()
            }
        }

        viewModel.searchText = "shut"

        await fulfillment(of: [searchExpectation], timeout: 1.0)
        cancellable.cancel()

        XCTAssertEqual(viewModel.movies.count, 1)
    }

    @MainActor
    func test_VM_SearchMovie_ReturnsEmptyMoviesWhenSearchTextDoesMatch() async {
        let viewModel = makeSut(scenario: .movies([
            Movie.mock(id: 1, title: "Shuttle Island"),
            Movie.mock(id: 2, title: "Inception"),
        ]))
        let searchExpectation = expectation(description: "Search expectation")

        let cancellable = viewModel.$movies.sink { movies in
            if movies.count == 0 {
                searchExpectation.fulfill()
            }
        }

        viewModel.searchText = "Inter"

        await fulfillment(of: [searchExpectation], timeout: 1.0)
        cancellable.cancel()

        XCTAssertEqual(viewModel.movies.count, 0)
    }

    @MainActor
    func test_VM_NetworkWhenOfflineAndListEmpty_ShowsCheckInternetError() async {
        let connection = MockNetworkMonitor()

        let repo = MockMovieRepository(scenario: .movies([]))

        let viewModel = MovieListViewModel(repo: repo, connectionMonitor: connection)

        XCTAssertNil(viewModel.error)

        connection.simulateConnectionChange(isConnected: false)
        try? await Task.sleep(for: .milliseconds(300))

        XCTAssertEqual(viewModel.error, String.checkInternet)
    }

    @MainActor
    func test_VM_NetworkWhenOnlineAndListEmpty_FetchesMovies() async {
        let connection = MockNetworkMonitor()
        connection.simulateConnectionChange(isConnected: false)

        let repo = MockMovieRepository(scenario: .movies([
            Movie.mock(id: 1, title: "Shuttle Island"),
            Movie.mock(id: 2, title: "Inception"),
        ]))

        let viewModel = MovieListViewModel(repo: repo, connectionMonitor: connection)

        XCTAssertTrue(viewModel.movies.isEmpty)
        connection.simulateConnectionChange(isConnected: true)
        try? await Task.sleep(for: .milliseconds(300))

        XCTAssertFalse(viewModel.movies.isEmpty)
    }

    @MainActor
    func test_VM_NetworkWhenOnlineAndListEmpty_SearchesMovies() async {
        let connection = MockNetworkMonitor()
        connection.simulateConnectionChange(isConnected: false)

        let repo = MockMovieRepository(scenario: .movies([
            Movie.mock(id: 1, title: "Shuttle Island"),
            Movie.mock(id: 2, title: "Inception"),
        ]))

        let viewModel = MovieListViewModel(repo: repo, connectionMonitor: connection)
        viewModel.searchText = "Inception"

        XCTAssertTrue(viewModel.movies.isEmpty)
        connection.simulateConnectionChange(isConnected: true)
        try? await Task.sleep(for: .milliseconds(300))

        XCTAssertFalse(viewModel.movies.isEmpty)
    }

    @MainActor
    func test_VM_SelectionModeWhenSetToFavorite_ShowsFavoritesOnly() async {
        let viewModel = makeSut(scenario: .favorites(movies))

        XCTAssertTrue(viewModel.movies.isEmpty)

        viewModel.selectedMode = .favorites

        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(viewModel.movies.count, 1)
    }

    // MARK: - Helper

    private var movies: [Movie] {
        return [Movie.mock(id: 1)]
    }

    private var detailMovie: MovieDetail {
        return MovieDetail.mock(id: 1)
    }

    private var errorScenario: MovieMockScenario {
        .error(URLError(.badServerResponse))
    }

    @MainActor
    private func makeSut(scenario: MovieMockScenario) -> MovieListViewModel {
        return MovieListViewModel(repo: MockMovieRepository(scenario: scenario))
    }
}
