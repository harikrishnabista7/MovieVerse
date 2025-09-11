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

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        do {
            let details = try await network.getMovieDetail(id: id)

            do {
                try await cache.saveMovieDetail(details)
            } catch {
                AppLogger.error(error.localizedDescription)
            }

            return details
        } catch {
            return try await cache.getMovieDetail(id: id)
        }
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
