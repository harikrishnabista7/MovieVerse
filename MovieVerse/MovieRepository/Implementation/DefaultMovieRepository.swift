//
//  DefaultMovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

struct DefaultMovieRepository: MovieRepository {
    let network: MovieDataSource
    let cache: MovieCacheDataSource

    init(network: MovieDataSource, cache: MovieCacheDataSource) {
        self.network = network
        self.cache = cache
    }

    func getMovies() -> AsyncThrowingStream<[Movie], Error> {
        AsyncThrowingStream { continuation in
            // Create a Task for async work
            let task = Task {
                // Yield cached movies first
                do {
                    let cachedMovies = try await self.cache.getMovies()
                    if !cachedMovies.isEmpty {
                        continuation.yield(cachedMovies)
                    }
                } catch {
                    AppLogger.error(error.localizedDescription)
                }

                do {
                    // Fetch from network
                    let networkMovies = try await network.getMovies()

                    // Yield network movies
                    continuation.yield(networkMovies)

                    // Save to cache
                    await saveToCache(networkMovies)

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            // Handle stream cancellation
            continuation.onTermination = { @Sendable _ in
                task.cancel() // cancel the Task if stream is cancelled
            }
        }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        do {
            let networkMovies = try await network.searchMovies(query: query)

            await saveToCache(networkMovies)

            return networkMovies
        } catch {
            return try await cache.searchMovies(query: query)
        }
    }

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
        do {
            let detail = try await network.getMovieDetail(id: id)

            do {
                try await cache.saveMovieDetail(detail)
            } catch {
                AppLogger.error(error.localizedDescription)
            }

            return detail
        } catch {
            return try await cache.getMovieDetail(id: id)
        }
    }

    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie] {
        if NetworkMonitor.shared.isConnected {
            return try await network.getMoviesPage(searchQuery: searchQuery, after: lastMovieId)
        } else {
            return try await cache.getMoviesPage(searchQuery: searchQuery, after: lastMovieId)
        }
    }

    func addMovieToFavorites(_ movieId: Int32) async throws {
        try await cache.addMovieToFavorites(movieId)
    }

    func removeMovieFromFavorites(_ movieId: Int32) async throws {
        try await cache.removeMovieFromFavorites(movieId)
    }

    func isFavoriteMovie(_ movieId: Int32) async throws -> Bool {
        try await cache.isFavoriteMovie(movieId)
    }

    func favoriteMovies(query: String) async throws -> [Movie] {
        try await cache.favoriteMovies(query: query)
    }

    private func saveToCache(_ movies: [Movie]) async {
        do {
            try await cache.saveMovies(movies)
        } catch {
            AppLogger.error(error.localizedDescription)
        }
    }

    private func selectDataSource() -> MovieDataSource {
        NetworkMonitor.shared.isConnected
            ? network
            : cache
    }
}
