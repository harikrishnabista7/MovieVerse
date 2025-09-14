//
//  MockMovieNetworkDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//


final class MockMovieNetworkDataSource: MovieDataSource {
    let scenario: MovieMockScenario
    let delay: UInt64
    
    private(set) var favoriteMovies: Set<Int32> = []


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
    
    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie] {
        try await Task.sleep(nanoseconds: delay)

        return try handleMoviesScenario()
    }
    
    func addMovieToFavorites(_ movieId: Int32) async throws {
        favoriteMovies.insert(movieId)
    }
    
    func removeMovieFromFavorites(_ movieId: Int32) async throws {
        favoriteMovies.remove(movieId)
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
