//
//  MockMovieNetworkDataSource.swift
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

struct MockMovieNetworkDataSource: MovieDataSource {
    let scenario: MovieMockScenario
    let delay: UInt64

    init(scenario: MovieMockScenario, delay: UInt64 = 1_000_000_000) {
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

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
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
