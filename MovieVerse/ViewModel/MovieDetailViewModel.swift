//
//  MovieDetailViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import Combine
import Foundation

//@MainActor
//final class MovieDetailViewModel: ObservableObject {
//    @Published var detail: MovieDetail?
//    @Published var isLoading: Bool = false
//    @Published var error: String?
//    @Published var isFavorite: Bool = false
//    @Published var alertError: Bool = false
//
//    private let movieRepo: MovieRepository
//    private let movieId: Int32
//    private var cancellables: Set<AnyCancellable> = []
//    private let connectionMonitor: any ConnectionMonitor
//
//    init(movieId: Int32, movieRepo: MovieRepository, connectionMonitor: any ConnectionMonitor = NetworkMonitor.shared) {
//        self.movieId = movieId
//        self.movieRepo = movieRepo
//        self.connectionMonitor = connectionMonitor
//        observeNetworkChange()
//    }
//
//    /// Loads movie detail from movie repo
//    func getMovieDetail() async {
//        isLoading = true
//
//        defer {
//            isLoading = false
//        }
//        do {
//            detail = try await movieRepo.getMovieDetail(id: movieId)
//            isFavorite = try await movieRepo.isFavoriteMovie(movieId)
//        } catch {
//            self.error = connectionMonitor.isConnected ? .noDetailFound : .checkInternet
//        }
//    }
//
//    /// Observes the network change and when internet available it loads details automatically if not loaded yet.
//    private func observeNetworkChange() {
//        connectionMonitor.isConnectedPublisher
//            .dropFirst() // Skip initial ConnectionMonitor emissions to prevent immediate API calls
//            .drop(while: { [weak self] _ in
//                self?.detail != nil
//            })
//            .sink { [weak self] isConnected in
//                if isConnected {
//                    Task {
//                        await self?.getMovieDetail()
//                    }
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    func toggleFavorite() {
//        guard let detail = detail else { return }
//        Task {
//            do {
//                if isFavorite {
//                    try await movieRepo.removeMovieFromFavorites(detail.id)
//                } else {
//                    try await movieRepo.addMovieToFavorites(detail.id)
//                }
//                isFavorite.toggle()
//            } catch {
//                self.error = "Failed to toggle favorite status"
//                self.alertError = true
//            }
//        }
//    }
//}
@MainActor
final class MovieDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var detail: MovieDetail?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isFavorite: Bool = false
    @Published var error: String?
    @Published var alertError: Bool = false

    // MARK: - Private Properties
    private let movieRepo: MovieRepository
    private let movieId: Int32
    private let connectionMonitor: any ConnectionMonitor
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(
        movieId: Int32,
        movieRepo: MovieRepository,
        connectionMonitor: any ConnectionMonitor = NetworkMonitor.shared
    ) {
        self.movieId = movieId
        self.movieRepo = movieRepo
        self.connectionMonitor = connectionMonitor
        observeNetworkChange()
    }

    // MARK: - Public API
    func getMovieDetail() async {
        isLoading = true
        defer { isLoading = false }

        do {
            detail = try await movieRepo.getMovieDetail(id: movieId)
            isFavorite = try await movieRepo.isFavoriteMovie(movieId)
        } catch {
            handleError(error, fallback: connectionMonitor.isConnected ? .noDetailFound : .checkInternet)
        }
    }

    func toggleFavorite() {
        guard let detail else { return }

        Task {
            do {
                try await updateFavoriteStatus(for: detail.id)
                isFavorite.toggle()
            } catch {
                handleError(error, fallback: "Failed to toggle favorite status", alert: true)
            }
        }
    }

    // MARK: - Private Helpers
    private func observeNetworkChange() {
        connectionMonitor.isConnectedPublisher
            .dropFirst()
            .drop(while: { [weak self] _ in self?.detail != nil })
            .sink { [weak self] isConnected in
                guard isConnected, let self else { return }
                Task { await self.getMovieDetail() }
            }
            .store(in: &cancellables)
    }

    private func updateFavoriteStatus(for id: Int32) async throws {
        if isFavorite {
            try await movieRepo.removeMovieFromFavorites(id)
        } else {
            try await movieRepo.addMovieToFavorites(id)
        }
    }

    private func handleError(_ error: Error, fallback: String, alert: Bool = false) {
        AppLogger.error(error.localizedDescription)
        self.error = fallback
        self.alertError = alert
    }
}
