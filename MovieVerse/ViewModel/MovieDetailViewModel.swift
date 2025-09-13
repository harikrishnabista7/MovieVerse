//
//  MovieDetailViewModel.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import Foundation
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var error: String?

    private let movieRepo: MovieRepository
    private let movieId: Int32
    private var cancellables: Set<AnyCancellable> = []

    init(movieId: Int32, movieRepo: MovieRepository) {
        self.movieId = movieId
        self.movieRepo = movieRepo
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
            self.error = NetworkMonitor.shared.isConnected ? "No detail found" : "Please check your internet connection"
        }
    }
    

    private func observeNetworkChange() {
        NetworkMonitor.shared.$isConnected
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
