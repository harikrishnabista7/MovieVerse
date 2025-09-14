//
//  MockMovieCacheDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//

final class MockMovieCacheDataSource: MovieCacheDataSource {
    let scenario: MovieMockScenario

    private(set) var isCacheCalled = false
    private(set) var savedMovies: [Movie] = []
    private(set) var savedDetail: MovieDetail?
    private(set) var favoriteMovies: Set<Int32> = []

    init(scenario: MovieMockScenario) {
        self.scenario = scenario
    }

    func getMovies() async throws -> [Movie] {
        return try handleMoviesScenario()
    }

    func searchMovies(query: String) async throws -> [Movie] {
        return try handleMoviesScenario()
    }

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
        if case let .detail(detail) = scenario {
            return detail
        }
        throw MockError(errorMessage: "Unexpected scenario for getMovieDetails")
    }

    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie] {
        return try handleMoviesScenario()
    }

    func addMovieToFavorites(_ movieId: Int32) async throws {
        favoriteMovies.insert(movieId)
    }

    func removeMovieFromFavorites(_ movieId: Int32) async throws {
        favoriteMovies.remove(movieId)
    }

    func isFavoriteMovie(_ movieId: Int32) async throws -> Bool {
        favoriteMovies.contains(movieId)
    }

    func favoriteMovies(query: String) async throws -> [Movie] {
        try handleMoviesScenario()
    }

    private func handleMoviesScenario() throws -> [Movie] {
        switch scenario {
        case let .movies(movies), let .favorites(movies):
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
