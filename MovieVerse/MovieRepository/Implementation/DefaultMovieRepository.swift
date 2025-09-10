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
                do {
                    // Yield cached movies first
                    let cachedMovies = try await cache.getMovies()
                    if !cachedMovies.isEmpty {
                        continuation.yield(cachedMovies)
                    }

                    // Fetch from network
                    let networkMovies = try await network.getMovies()

                    // Save to cache asynchronously

                    Task {
                        await saveToCache(networkMovies)
                    }

                    // Yield network movies
                    continuation.yield(networkMovies)
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

            Task {
                await saveToCache(networkMovies)
            }

            return networkMovies
        } catch {
            return try await cache.searchMovies(query: query)
        }
    }

    func getMovieDetails(id: Int) async throws -> MovieDetail {
        do {
            let details = try await network.getMovieDetails(id: id)

            Task {
                do {
                    try await cache.saveMovieDetail(details)
                } catch {
                    AppLogger.error(error.localizedDescription)
                }
            }
            return details
        } catch {
            return try await cache.getMovieDetails(id: id)
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
