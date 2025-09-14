//
//  MovieDetailViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import Combine
import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var error: String?

    private let movieRepo: MovieRepository
    private let movieId: Int32
    private var cancellables: Set<AnyCancellable> = []
    private let connectionMonitor: any ConnectionMonitor

    init(movieId: Int32, movieRepo: MovieRepository, connectionMonitor: any ConnectionMonitor = NetworkMonitor.shared) {
        self.movieId = movieId
        self.movieRepo = movieRepo
        self.connectionMonitor = connectionMonitor
        observeNetworkChange()
    }

    /// Loads movie detail from movie repo
    func getMovieDetail() async {
        isLoading = true

        defer {
            isLoading = false
        }
        do {
            detail = try await movieRepo.getMovieDetail(id: movieId)
        } catch {
            self.error = connectionMonitor.isConnected ? .noDetailFound : .checkInternet
        }
    }

    /// Observes the network change and when internet available it loads details automatically if not loaded yet.
    private func observeNetworkChange() {
        connectionMonitor.isConnectedPublisher
            .dropFirst(2) // Skip initial ConnectionMonitor emissions to prevent immediate API calls
            .drop(while: { [weak self] _ in
                self?.detail != nil
            })
            .sink { [weak self] isConnected in
                if isConnected {
                    Task {
                        await self?.getMovieDetail()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
