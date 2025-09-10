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
                let movies = try await network.getMovies()
                continuation.yield(movies)
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
