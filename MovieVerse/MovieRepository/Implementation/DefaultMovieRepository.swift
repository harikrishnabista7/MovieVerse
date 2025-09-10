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
            Task {
                let cachedMovies = try await cache.getMovies()
                if !cachedMovies.isEmpty {
                    continuation.yield(cachedMovies)
                }

                let networkMovies = try await network.getMovies()
                continuation.yield(networkMovies)
                do {
                    try await cache.saveMovies(networkMovies)
                } catch {
                    AppLogger.error(error.localizedDescription)
                }

                continuation.finish()
            }
        }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        return []
    }

    func getMovieDetails(id: Int) async throws -> MovieDetail {
        .init(title: "", id: 0)
    }
}
