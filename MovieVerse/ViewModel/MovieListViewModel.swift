//
//  MovieListViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

import Combine
import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var error: String?
    @Published var searchText: String = ""

    private let movieRepo: MovieRepository
    private var cancellables: Set<AnyCancellable> = []

    private var originalMovies: [Movie] = []
    private var searchedMovies: [Movie] = []

    private var searchTask: Task<Void, Never>?

    init(repo: MovieRepository) {
        movieRepo = repo
        observeTextChanged()
    }

    func loadMovies() async {
        do {
            for try await batch in movieRepo.getMovies() { // show latest stream
                movies = batch
                originalMovies = batch
            }
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func searchMovies(query: String) {
        searchTask?.cancel()
        if query.isEmpty {
            movies = originalMovies
        } else {
            searchTask = Task { [weak self] in
                guard let self else { return }
                do {
                    guard !Task.isCancelled else { return }
                    
                    let movies = try await self.movieRepo.searchMovies(query: query)
                    searchedMovies = movies
                    self.movies = movies
                } catch {
                    AppLogger.error(error.localizedDescription)
                }
            }

        }
    }

    private func observeTextChanged() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchMovies(query: query)
            }
            .store(in: &cancellables)
    }
}
