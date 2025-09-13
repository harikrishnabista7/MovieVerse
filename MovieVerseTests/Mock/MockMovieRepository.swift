//
//  MockMovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 12/09/2025.
//
import Foundation
@testable import MovieVerse

struct MockMovieRepository: MovieRepository {
    private let scenario: MovieMockScenario

    init(scenario: MovieMockScenario) {
        self.scenario = scenario
    }

    func getMovies() -> AsyncThrowingStream<[Movie], any Error> {
        AsyncThrowingStream { continuation in
            switch scenario {
            case let .movies(movies):
                continuation.yield(movies) // cache load first test

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
