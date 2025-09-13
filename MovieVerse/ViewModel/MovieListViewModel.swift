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
    @Published var isLoading: Bool = false

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
        guard searchText.isEmpty else {
            return
        }
        
        isLoading = movies.isEmpty
        error = nil

        do {
            for try await batch in movieRepo.getMovies() { // show latest stream
                movies = batch
                originalMovies = batch
            }
        } catch {
            AppLogger.error(error.localizedDescription)
        }
        isLoading = false
        error = movies.isEmpty ? "No movies found" : nil
    }

    private func searchMovies(query: String) {
        error = nil
        isLoading = movies.isEmpty

        searchTask?.cancel()
        if query.isEmpty {
            movies = originalMovies
            isLoading = false
        } else {
            searchTask = Task { [weak self] in
                guard let self else { return }
                do {
                    guard !Task.isCancelled else {
                        isLoading = false
                        return
                    }

                    let movies = try await self.movieRepo.searchMovies(query: query.trimmingCharacters(in: .whitespacesAndNewlines))
                    searchedMovies = movies
                    self.movies = movies

                } catch {
                    AppLogger.error(error.localizedDescription)
                }
                isLoading = false
                error = movies.isEmpty ? "No movies found" : nil
            }
        }
    }

    private func observeTextChanged() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchMovies(query: query)
            }
            .store(in: &cancellables)
    }
}
