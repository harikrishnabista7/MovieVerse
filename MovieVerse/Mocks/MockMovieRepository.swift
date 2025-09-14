//
//  MockMovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//
import Foundation

struct MockMovieRepository: MovieRepository {
    private let scenario: MovieMockScenario
    private let ignoreCache: Bool
    private let delay: TimeInterval

    init(scenario: MovieMockScenario, ignoreCache: Bool = false, delay: TimeInterval = 0.0) {
        self.scenario = scenario
        self.ignoreCache = ignoreCache
        self.delay = delay
    }

    func getMovies() -> AsyncThrowingStream<[Movie], any Error> {
        AsyncThrowingStream { continuation in
            switch scenario {
            case let .movies(movies):
                if !ignoreCache {
                    continuation.yield(movies) // cache load first test
                }

                Thread.sleep(forTimeInterval: 0.1)
                continuation.yield(movies) // network load second

                continuation.finish()
            case let .error(error):
                continuation.finish(throwing: error)
            default:
                assertionFailure("Unsupported scenario for getMovies")
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
            fatalError("Unsupported scenario for searchMovies")
        }
    }

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
        try? await Task.sleep(for: .milliseconds(UInt64(delay)))

        switch scenario {
        case let .detail(detail):
            return detail
        case let .error(error):
            throw error
        default:
            fatalError("Unsupported scenario for getMovieDetail")
        }
    }
}
