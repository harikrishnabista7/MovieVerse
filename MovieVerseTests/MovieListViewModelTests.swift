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

