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

    func test_DMR_GetMovies_CacheLoadFirst_ThenNetworkSecond() async {
        let network = networkDataSource(scenario: .movies(networkMovies))
        let cache = cacheDataSource(scenario: .movies(cachedMovies))

        let sut = makeSUT(network: network, cache: cache)

        do {
            var emissions: [[Movie]] = []

            for try await batch in sut.getMovies() {
                emissions.append(batch)
            }
            XCTAssertEqual(emissions.count, 2)
            XCTAssertEqual(emissions[0], cachedMovies) // first emission = cache
            XCTAssertEqual(emissions[1], networkMovies) // second emission = network
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_DMR_GetMovies_WhenNetworkSuccess_CacheCalled() {
        
    }

    func test_DMR_GetMovies_ThrowsError() {
    }

    func test_DMR_GetMovies_WhenCacheLoadFails_LoadFromNetworkSucceeds() {
    }

    func test_DMR_GetMovies_WhenCacheLoadsSuccess_LoadFromNetworkThrowsError() {
    }

    // MARK: - Search Movies

    func test_DMR_SearchMovies_LoadSucceeds() {
    }

    func test_DMR_SearchMovies_WhenSuccess_CacheCalled() {
    }

    func test_DMR_SearchMovies_WhenNetworkLoadFails_LoadFromCacheSucceeds() {
    }

    func test_DMR_SearchMovies_WhenNetworkLoadFails_LoadFromCacheThrowsError() {
    }

    // MARK: - Get Movie Detail

    func test_DMR_GetMovieDetail_LoadSucceeds() {
    }

    func test_DMR_GetMovieDetail_WhenSuccess_CacheCalled() {
    }

    func test_DMR_GetMovieDwetail_WhenNetworkFails_LoadFromCacheSucceeds() {
    }

    func test_DMR_GetMovieDwetail_WhenNetworkFails_LoadFromCacheThrowsError() {
    }

    // MARK: - Helper

    private var cachedMovies: [Movie] {
        return [Movie.mock(id: 2)]
    }

    private var networkMovies: [Movie] {
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

    private func networkDataSource(scenario: MovieMockScenario) -> MovieDataSource {
        return MockMovieNetworkDataSource(scenario: scenario)
    }

    private func cacheDataSource(scenario: MovieMockScenario) -> MovieCacheDataSource {
        return MockMovieCacheDataSource(scenario: scenario)
    }
}
