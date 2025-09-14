//
//  MovieListViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

import Combine
import Foundation

enum MovieListMode: String, CaseIterable {
    case movies = "Movies"
    case favorites = "Favorites"
}

@MainActor
final class MovieListViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var movies: [Movie] = []
    @Published private(set) var error: String?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedMode: MovieListMode = .movies {
        didSet { refreshMovies() }
    }

    // MARK: - Private Properties

    private let movieRepo: MovieRepository
    private let connectionMonitor: any ConnectionMonitor
    private var cancellables: Set<AnyCancellable> = []
    private var originalMovies: [Movie] = []
    private var searchTask: Task<Void, Never>?
    private var isFetchingMore: Bool = false

    // MARK: - Init

    init(repo: MovieRepository, connectionMonitor: any ConnectionMonitor = NetworkMonitor.shared) {
        movieRepo = repo
        self.connectionMonitor = connectionMonitor
        observeTextChanged()
        observeNetworkChange()
    }

    // MARK: - Public API

    func loadMovies() async {
        guard selectedMode == .movies else {
            await loadFavorites()
            return
        }

        isLoading = true
        error = nil

        do {
            for try await batch in movieRepo.getMovies() {
                movies = batch
                originalMovies = batch
            }
            handleEmptyState()
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    func fetchMoreMovies() async {
        guard selectedMode == .movies, !isFetchingMore else { return }

        isFetchingMore = true
        defer { isFetchingMore = false }

        do {
            let moreMovies = try await movieRepo.getMoviesPage(
                searchQuery: searchText.nonEmptyOrNil,
                after: movies.last?.id
            )

            let existingIds = Set(movies.map(\.id))
            let uniqueMovies = moreMovies.filter { !existingIds.contains($0.id) }
            movies += uniqueMovies

            if searchText.isEmpty {
                originalMovies = movies
            }
        } catch {
            handleError(error)
        }
    }

    // MARK: - Private Helpers

    private func searchMovies(query: String) {
        guard selectedMode == .movies else {
            Task { await loadFavorites() }
            return
        }

        error = nil
        isLoading = movies.isEmpty
        searchTask?.cancel()

        if query.isEmpty {
            movies = originalMovies
            isLoading = false
            return
        }

        movies = []
        searchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let results = try await movieRepo.searchMovies(query: query.trimmed)
                self.movies = results
                self.handleEmptyState()
            } catch {
                self.handleError(error)
            }
            self.isLoading = false
        }
    }

    private func loadFavorites() async {
        do {
            movies = try await movieRepo.favoriteMovies(query: searchText)
        } catch {
            handleError(error)
        }
    }

    private func refreshMovies() {
        switch selectedMode {
        case .movies:
            searchMovies(query: searchText)
        case .favorites:
            Task { await loadFavorites() }
        }
    }

    private func handleEmptyState() {
        if movies.isEmpty {
            error = connectionMonitor.isConnected ? .noMoviesFound : .checkInternet
        }
    }

    private func handleError(_ error: Error) {
        AppLogger.error(error.localizedDescription)
        if movies.isEmpty {
            self.error = connectionMonitor.isConnected ? .noMoviesFound : .checkInternet
        }
    }

    // MARK: - Observers

    private func observeTextChanged() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchMovies(query: query)
            }
            .store(in: &cancellables)
    }

    private func observeNetworkChange() {
        connectionMonitor.isConnectedPublisher
            .dropFirst()
            .drop(while: { [weak self] _ in self?.movies.isEmpty == false })
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                if isConnected {
                    Task {
                        if self.searchText.isEmpty {
                            await self.loadMovies()
                        } else {
                            self.searchMovies(query: self.searchText)
                        }
                    }
                } else if self.movies.isEmpty {
                    self.error = .checkInternet
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Convenience Extensions

private extension String {
    var nonEmptyOrNil: String? { isEmpty ? nil : self }
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
