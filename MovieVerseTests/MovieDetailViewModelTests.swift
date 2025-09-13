//
//  MovieDetailViewModelTests.swift
//  MovieVerseTests
//
//  Created by hari krishna on 14/09/2025.
//

@testable import MovieVerse
import XCTest

final class MovieDetailViewModelTests: XCTestCase {
    @MainActor
    func test_VM_GetMovieDetail_ShowsDetails() async {
        let repo = MockMovieRepository(scenario: .detail(.mock(id: 1)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo)

        await viewModel.getMovieDetail()
        XCTAssertEqual(viewModel.detail?.id, 1)
    }

    @MainActor
    func test_VM_GetMovieDetail_ShowsError() async {
        let repo = MockMovieRepository(
            scenario: .error(URLError(.badServerResponse)))
        let viewModel = MovieDetailViewModel(movieId: 1, movieRepo: repo)

        await viewModel.getMovieDetail()
        XCTAssertTrue(viewModel.error != nil)
    }
}
