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

    private func observeNetworkChange() {
        connectionMonitor.isConnectedPublisher
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
