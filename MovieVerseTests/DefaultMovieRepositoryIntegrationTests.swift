//
//  DefaultMovieRepositoryIntegrationTests.swift
//  MovieVerseTests
//
//  Created by hari krishna on 12/09/2025.
//

@testable import MovieVerse
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
}
