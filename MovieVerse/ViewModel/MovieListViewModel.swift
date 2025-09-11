//
//  MovieListViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var error: String?
    
    private let movieRepo: MovieRepository
    
    init(repo: MovieRepository) {
        movieRepo = repo
    }
    
    func loadMovies() async {
        do {
            for try await movie in movieRepo.getMovies() { // show latest stream
                movies = movie
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
}
