//
//  DefaultMovieRepositoryIntegrationTests.swift
//  MovieVerseTests
//
//  Created by hari krishna on 12/09/2025.
//

@testable import MovieVerse
import CoreData
import XCTest

final class DefaultMovieRepositoryIntegrationTests: XCTestCase {
    @MainActor
    func test_DMR_GetMovies_ShouldReturnMovies() async {
        let network = MovieNetworkDataSource(client: DefaultNetworkClient(), requestMaker: NetworkRequestMaker(authHeaderProvider: BearerAuthHeaderProvider(token: Config.movieAccessToken ?? "")))
        let cache = MovieCoreDataCacheDataSource(controller: .preview)

        let repository = DefaultMovieRepository(network: network, cache: cache)

        do {
            var movies: [Movie] = []
            for try await batch in repository.getMovies() {
                movies = batch
            }
            XCTAssertTrue(movies.count > 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    @MainActor
    func test_DMR_GetMovies_ShouldSaveMoviesToDatabase() async {
        let network = MovieNetworkDataSource(client: DefaultNetworkClient(), requestMaker: NetworkRequestMaker(authHeaderProvider: BearerAuthHeaderProvider(token: Config.movieAccessToken ?? "")))
        let cache = MovieCoreDataCacheDataSource(controller: .preview)

        let repository = DefaultMovieRepository(network: network, cache: cache)

        do {
            for try await _ in repository.getMovies() { }
            let movies = try await cache.getMovies()
            XCTAssertTrue(movies.count > 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
//    @MainActor
//    func test_DMR_SearchMovies_ShouldReturnMoviesFromQuery() async {
//        let network = MovieNetworkDataSource(client: DefaultNetworkClient(), requestMaker: NetworkRequestMaker(authHeaderProvider: BearerAuthHeaderProvider(token: Config.movieAccessToken ?? "")))
//        let cache = MovieCoreDataCacheDataSource(controller: .preview)
//
//        let repository = DefaultMovieRepository(network: network, cache: cache)
//
//        do {
//            for try await _ in repository.getMovies() { }
//            let movies = try await cache.getMovies()
//            XCTAssertTrue(movies.count > 0)
//        } catch {
//            XCTFail(error.localizedDescription)
//        }
//    }
}
