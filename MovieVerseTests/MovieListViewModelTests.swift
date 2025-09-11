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

struct MockMovieRepository: MovieRepository {
    private let scenario: MovieMockScenario

    init(scenario: MovieMockScenario) {
        self.scenario = scenario
    }

    func getMovies() -> AsyncThrowingStream<[Movie], any Error> {
        AsyncThrowingStream { continuation in
            switch scenario {
            case let .movies(movies):
                continuation.yield(movies) // cache load first test

                Thread.sleep(forTimeInterval: 0.1)
                continuation.yield(movies) // network load second

                continuation.finish()
            case let .error(error):
                continuation.finish(throwing: error)
            default:
                assertionFailure("Unsupported scenario for getMovies")
            }
        }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        []
    }

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        .init(title: "fsf", id: 1)
    }
}
