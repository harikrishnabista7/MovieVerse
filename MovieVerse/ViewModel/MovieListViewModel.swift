//
//  MovieListViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

import Combine
import Foundation

/// Movies list mode to toggle the list content
enum MovieListMode: String, CaseIterable {
    case movies = "Movies"
    case favorites = "Favorites"
}

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var error: String?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedMode: MovieListMode = .movies {
        didSet {
            selectedMode == .movies ? showMovieLists() : showFavorites()
        }
    }

    private let movieRepo: MovieRepository
    private let connectionMonitor: any ConnectionMonitor
    private var cancellables: Set<AnyCancellable> = []

    private var originalMovies: [Movie] = []
//    private var searchedMovies: [Movie] = []

    private var searchTask: Task<Void, Never>?

    private var isFetchingMore: Bool = false

    init(repo: MovieRepository, connectionMonitor: any ConnectionMonitor = NetworkMonitor.shared) {
        movieRepo = repo
        self.connectionMonitor = connectionMonitor
        observeTextChanged()
        observeNetworkChange()
    }

    /// Load movies from movie repo asynchronously
    func loadMovies() async {
        isLoading = true
        error = nil
        guard searchText.isEmpty else {
            isLoading = false
            return
        }
        do {
            for try await batch in movieRepo.getMovies() {
                movies = batch
                originalMovies = batch
            }
        } catch {
            AppLogger.error(error.localizedDescription)
        }
        isLoading = false
        if movies.isEmpty {
            error = connectionMonitor.isConnected ? .noMoviesFound : .checkInternet
        }
    }

    func fetchMoreMovies() async {
        guard !isFetchingMore else {
            return
        }
        isFetchingMore = true
        let lastMovieId = movies.last?.id
        let searchQuery = searchText.isEmpty ? nil : searchText

        do {
            let moreMovies = try await movieRepo.getMoviesPage(searchQuery: searchQuery, after: lastMovieId)
            let existingIds = Set(movies.map { $0.id })
            let uniqueMovies = moreMovies.filter { !existingIds.contains($0.id) }
            movies += uniqueMovies

            if searchQuery == nil {
                originalMovies = movies
            }
        } catch {
            debugPrint(error)
        }
        isFetchingMore = false
    }

    /// Search for movies in the movie repo based on the title of the movie
    /// - Parameter query: movie name that contains the query
    private func searchMovies(query: String) {
        error = nil
        isLoading = movies.isEmpty

        searchTask?.cancel()
        if query.isEmpty {
            movies = originalMovies
            isLoading = false
        } else {
            movies = []
            searchTask = Task { [weak self] in
                guard let self else { return }
                do {
                    guard !Task.isCancelled else {
                        isLoading = false
                        return
                    }

                    let movies = try await self.movieRepo.searchMovies(query: query.trimmingCharacters(in: .whitespacesAndNewlines))
                    self.movies = movies

                } catch {
                    AppLogger.error(error.localizedDescription)
                }
                isLoading = false
                if movies.isEmpty {
                    error = connectionMonitor.isConnected ? .noMoviesFound : .checkInternet
                }
            }
        }
    }

    /// Observes the changes to search text and search the movie repo for movie with name containing search text
    private func observeTextChanged() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchMovies(query: query)
            }
            .store(in: &cancellables)
    }

    /// Observes the network change and when internet available it loads details automatically if not loaded yet.
    private func observeNetworkChange() {
        connectionMonitor.isConnectedPublisher
            .dropFirst() // Skip initial ConnectionMonitor emissions to prevent immediate API calls
            .drop(while: { [weak self] _ in
                self?.movies.isEmpty == false
            })
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                if isConnected {
                    if self.searchText.isEmpty {
                        Task {
                            await self.loadMovies()
                        }
                    } else {
                        self.searchMovies(query: self.searchText)
                    }
                } else {
                    if self.movies.isEmpty {
                        self.error = .checkInternet
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func showMovieLists() {
        movies = originalMovies
    }
    
    private func showFavorites() {
        movies = []
    }
}
