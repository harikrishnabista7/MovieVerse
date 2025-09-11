//
//  MockMovieDataSource.swift
//  MovieVerseTests
//
//  Created by hari krishna on 11/09/2025.
//

import Foundation
@testable import MovieVerse

enum MovieMockScenario {
    case movies([Movie])
    case error(Error)
    case detail(MovieDetail)
}

struct MockMovieDataSource: MovieDataSource {
    let scenario: MovieMockScenario
    let delay: UInt64

    init(scenario: MovieMockScenario, delay: UInt64 = 1000000) {
        self.scenario = scenario
        self.delay = delay
    }

    func getMovies() async throws -> [Movie] {
        try await Task.sleep(nanoseconds: delay)

        return try handleMoviesScenario()
    }

    func searchMovies(query: String) async throws -> [Movie] {
        try await Task.sleep(nanoseconds: delay)

        return try handleMoviesScenario()
    }

    func getMovieDetails(id: Int) async throws -> MovieDetail {
        try await Task.sleep(nanoseconds: delay)

        if case let .detail(detail) = scenario {
            return detail
        }
        throw MockError(errorMessage: "Unexpected scenario for getMovieDetails")
    }

    private func handleMoviesScenario() throws -> [Movie] {
        switch scenario {
        case let .movies(movies):
            return movies
        case let .error(error):
            throw error
        default:
            throw MockError(errorMessage: "Unexpected scenario for movies")
        }
    }
}
