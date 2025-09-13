//
//  MovieDetailViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var error: String?

    private let movieRepo: MovieRepository
    private let movieId: Int32

    init(movieId: Int32, movieRepo: MovieRepository) {
        self.movieId = movieId
        self.movieRepo = movieRepo
    }

    func getMovieDetail() async {
        do {
            detail = try await movieRepo.getMovieDetail(id: movieId)
        } catch {
            self.error = "No detail found"
        }
    }
}
