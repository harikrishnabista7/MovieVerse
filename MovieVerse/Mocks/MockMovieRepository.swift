//
//  MockMovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//
import Foundation

final class MockMovieRepository: MovieRepository {
    private let scenario: MovieMockScenario
    private let excludeCacheSimulation: Bool
    private let delay: TimeInterval
    private(set) var favoriteMovies: Set<Int32> = []

    init(scenario: MovieMockScenario, excludeCacheSimulation: Bool = false, delay: TimeInterval = 0.0) {
        self.scenario = scenario
        self.excludeCacheSimulation = excludeCacheSimulation
        self.delay = delay
    }

    func getMovies() -> AsyncThrowingStream<[Movie], any Error> {
        AsyncThrowingStream { continuation in
            Task { // Wrap in Task to use async/await
                func handleMoviesScenario(_ movies: [Movie]) async {
                    // Use Task.sleep instead of Thread.sleep
                    try? await Task.sleep(for: .seconds(delay))

                    if !excludeCacheSimulation {
                        continuation.yield(movies)
                    }

                    // Use Task.sleep for the second delay too
                    try? await Task.sleep(for: .seconds(1.0))
                    continuation.yield(movies)

                    continuation.finish()
                }

                switch scenario {
                case let .movies(movies):
                    await handleMoviesScenario(movies)
                case let .movieWithDetail(movie, _):
                    await handleMoviesScenario([movie])
                case let .error(error):
                    continuation.finish(throwing: error)
                default:
                    assertionFailure("Unsupported scenario for getMovies")
                }
            }
        }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        try? await Task.sleep(for: .milliseconds(UInt64(delay)))

        switch scenario {
        case let .movies(movies):
            return movies.filter { $0.title.lowercased().contains(query.lowercased()) }
        case let .error(error):
            throw error
        default:
            return []
        }
    }
    
    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie] {
        switch scenario {
        case let .movies(movies):
            return movies
        case let .error(error):
            throw error
        default:
            return []
        }
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
        switch scenario {
        case let .movies(movies), let .favorites(movies):
            return movies
        case let .error(error):
            throw error
        default:
            return []
        }
    }

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
        try? await Task.sleep(for: .milliseconds(UInt64(delay)))

        switch scenario {
        case let .detail(detail):
            return detail
        case let .movieWithDetail(_, detail):
            return detail
        case let .error(error):
            throw error
        default:
            fatalError("Unsupported scenario for getMovieDetail")
        }
    }
   
}
