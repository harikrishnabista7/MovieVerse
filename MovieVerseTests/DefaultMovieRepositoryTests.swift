//
//  DefaultMovieRepositoryTests.swift
//  MovieVerseTests
//
//  Created by hari krishna on 11/09/2025.
//

@testable import MovieVerse
import XCTest

final class DefaultMovieRepositoryTests: XCTestCase {
    // MARK: - Get Movies

    func test_DMR_GetMovies_ShouldReturnMovies_FromCacheFirst_ThenFromNetworkSecond() async {
        let network = MockMovieNetworkDataSource(scenario: .movies(movies))
        let cachedMovies: [Movie] = [Movie.mock(id: 2)]
        let cache = MockMovieCacheDataSource(scenario: .movies(cachedMovies))

        let sut = makeSUT(network: network, cache: cache)

        do {
            var emissions: [[Movie]] = []

            for try await batch in sut.getMovies() {
                emissions.append(batch)
            }
            XCTAssertEqual(emissions.count, 2)
            XCTAssertEqual(emissions.first, cachedMovies) // first emission = cache
            XCTAssertEqual(emissions.last, movies) // second emission = network
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_GetMovies_ShouldCacheMovies() async {
        let network = MockMovieNetworkDataSource(scenario: .movies(movies))
        let cache = MockMovieCacheDataSource(scenario: .movies(movies))

        let sut = makeSUT(network: network, cache: cache)

        do {
            for try await _ in sut.getMovies() {}

            XCTAssertTrue(cache.isCacheCalled)
            XCTAssertEqual(cache.savedMovies, movies)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_GetMovies_ThrowsError() async {
        let network = MockMovieNetworkDataSource(scenario: errorScenario)
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)

        do {
            var emissions: [[Movie]] = []

            for try await batch in sut.getMovies() {
                emissions.append(batch)
            }
            XCTFail("Unexpected behavior, no error thrown")
        } catch let error {
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }

    func test_DMR_GetMovies_WhenCacheLoadFails_ShouldReturnMoviesFromNetwork() async {
        let network = MockMovieNetworkDataSource(scenario: .movies(movies))
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)

        do {
            var emissions: [[Movie]] = []

            for try await batch in sut.getMovies() {
                emissions.append(batch)
            }
            XCTAssertEqual(emissions.count, 1) // receives only network movies
            XCTAssertEqual(emissions.first, movies)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_GetMovies_ShouldReturnMoviesFromCache_ThenThrowErrorForNetworkLoad() async {
        let network = MockMovieNetworkDataSource(scenario: errorScenario)
        let cache = MockMovieCacheDataSource(scenario: .movies(movies))

        let sut = makeSUT(network: network, cache: cache)
        var emissions: [[Movie]] = []
        do {
            for try await batch in sut.getMovies() {
                emissions.append(batch)
            }
        } catch {
            XCTAssertEqual(emissions.count, 1) // receives only cache movies but network fails
            XCTAssertEqual(emissions.first, movies)
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }

    // MARK: - Search Movies

    func test_DMR_SearchMovies_ShouldReturnMovies() async {
        let network = MockMovieNetworkDataSource(scenario: .movies(movies))
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)
        do {
            let searchedMovies = try await sut.searchMovies(query: "")
            XCTAssertEqual(searchedMovies, movies)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_SearchMovies_ShouldCacheMovies() async {
        let network = MockMovieNetworkDataSource(scenario: .movies(movies)) // Loads from network
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)

        do {
            let _ = try await sut.searchMovies(query: "")
            XCTAssertTrue(cache.isCacheCalled)
            XCTAssertEqual(cache.savedMovies, movies)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_SearchMovies_WhenNetworkLoadFails_ShouldReturnMoviesFromCache() async {
        let network = MockMovieNetworkDataSource(scenario: errorScenario)
        let cache = MockMovieCacheDataSource(scenario: .movies(movies)) // Loads from cache

        let sut = makeSUT(network: network, cache: cache)

        do {
            let searchedMovies = try await sut.searchMovies(query: "")
            XCTAssertEqual(searchedMovies, movies)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_SearchMovies_ShouldThrowError() async {
        let network = MockMovieNetworkDataSource(scenario: errorScenario)
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)

        do {
            let _ = try await sut.searchMovies(query: "")
            XCTFail("Unexpected behavior, no error thrown")
        } catch let error {
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }

    // MARK: - Get Movie Detail

    func test_DMR_GetMovieDetail_ShouldReturnMovieDetail() async {
        let network = MockMovieNetworkDataSource(scenario: .detail(detailMovie)) // Loads from network
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)
        do {
            let detail = try await sut.getMovieDetail(id: detailMovie.id)
            XCTAssertEqual(detail, detailMovie)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_GetMovieDetail_ShouldCacheMovieDetail() async {
        let network = MockMovieNetworkDataSource(scenario: .detail(detailMovie)) // Loads from network
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)
        do {
            let _ = try await sut.getMovieDetail(id: detailMovie.id)
            XCTAssertTrue(cache.isCacheCalled)
            XCTAssertEqual(cache.savedDetail, detailMovie)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_GetMovieDwetail_WhenNetworkFails_ShouldReturnMovieDetailFromCache() async {
        let network = MockMovieNetworkDataSource(scenario: errorScenario)
        let cache = MockMovieCacheDataSource(scenario: .detail(detailMovie)) // Loads from cache

        let sut = makeSUT(network: network, cache: cache)
        do {
            let detail = try await sut.getMovieDetail(id: detailMovie.id)
            XCTAssertEqual(detail, detailMovie)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_GetMovieDwetail_ShouldThrowError() async {
        let network = MockMovieNetworkDataSource(scenario: errorScenario)
        let cache = MockMovieCacheDataSource(scenario: errorScenario)

        let sut = makeSUT(network: network, cache: cache)
        do {
            let _ = try await sut.getMovieDetail(id: detailMovie.id)
            XCTFail("Unexpected behavior, no error thrown")
        } catch let error {
            XCTAssert(error is MockError)
        }
    }

    // MARK: - Helper

    private var movies: [Movie] {
        return [Movie.mock(id: 1)]
    }

    private var detailMovie: MovieDetail {
        return MovieDetail.mock(id: 1)
    }

    private var errorScenario: MovieMockScenario {
        .error(URLError(.badServerResponse))
    }

    private func makeSUT(network: MovieDataSource,
                         cache: MovieCacheDataSource) -> DefaultMovieRepository {
        return DefaultMovieRepository(network: network, cache: cache)
    }
}
