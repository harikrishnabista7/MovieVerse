//
//  MockMovieCacheDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//
import Foundation
@testable import MovieVerse

final class MockMovieCacheDataSource: MovieCacheDataSource {
    let scenario: MovieMockScenario
    let delay: UInt64

    private(set) var isCacheCalled = false
    private(set) var savedMovies: [Movie] = []
    private(set) var savedDetail: MovieDetail?

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

    func getMovieDetail(id: Int) async throws -> MovieDetail {
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

    func saveMovieDetail(_ detail: MovieDetail) async throws {
        isCacheCalled = true
        savedDetail = detail
    }

    func saveMovies(_ movies: [Movie]) async throws {
        isCacheCalled = true
        savedMovies = movies
    }
}
