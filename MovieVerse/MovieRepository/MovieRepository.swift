//
//  MovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation

enum MovieRepositoryError: Error {
    case networkError
}

protocol MovieRepository {
    func getMovies() -> AsyncThrowingStream<[Movie], Error>
    func searchMovies(query: String) async throws -> [Movie]
    func getMovieDetails(id: Int) async throws -> MovieDetail
}

/*final class DefaultMovieRepository: MovieRepository {
    let network: MovieDataSource
    let cache: MovieCacheDataSource

    init(network: MovieDataSource, cache: MovieCacheDataSource) {
        self.network = network
        self.cache = cache
    }

    func getMovies() -> AsyncThrowingStream<[Movie], Error> {
        AsyncThrowingStream { continuation in
            
        }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        return []
    }

    func getMovieDetails(id: Int) async throws -> MovieDetail {
        .init(title: "", id: 0)
    }
}

protocol MovieDataSource {
    func getMovies() async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
    func getMovieDetails(id: Int) async throws -> MovieDetail
}

protocol MovieCacheDataSource: MovieDataSource {
    func saveMovies(_ movies: [Movie]) async throws
    func saveMovieDetail(_ detail: MovieDetail) async throws
}

struct MovieNetworkDataSource: MovieDataSource {
    func getMovies() -> [Movie] {
        return []
    }

    func searchMovies(query: String) -> [Movie] {
        return []
    }

    func getMovieDetails(id: Int) -> MovieDetail {
        .init(title: "", id: 0)
    }
}

struct CoreDataCacheMovieDataSource: MovieDataSource {
    func getMovies() -> [Movie] {
        return []
    }

    func searchMovies(query: String) -> [Movie] {
        return []
    }

    func getMovieDetails(id: Int) -> MovieDetail {
        .init(title: "", id: 0)
    }
}*/
