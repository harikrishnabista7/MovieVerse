//
//  MovieListView.swift
//  MovieVerse
//
//  Created by hari krishna on 12/09/2025.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel: MovieListViewModel

    init(repo: MovieRepository) {
        _viewModel = StateObject(wrappedValue: MovieListViewModel(repo: repo))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .accessibilityIdentifier("progressView")
            } else if viewModel.error != nil {
                Text(viewModel.error!)
                    .accessibilityIdentifier("errorText")
            } else {
                List {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(value: AppCoordinator.AppCoordinatorRoute.movieDetail(movie.id)) {
                            MovieRowView(movie: movie)
                        }
                        .accessibilityIdentifier("\(movie.id)")
                        .onAppear {
                            if viewModel.movies.last?.id == movie.id {
                                Task {
                                    await viewModel.fetchMoreMovies()
                                }
                            }
                        }
                    }
                }
                .accessibilityIdentifier("movieList")
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle(Text(verbatim: .movieVerse))
        .task {
            await viewModel.loadMovies()
        }
    }
}

#Preview {
    NavigationStack {
        let network = MovieNetworkDataSource(
            client: DefaultNetworkClient(),
            requestMaker: NetworkRequestMaker(authHeaderProvider: BearerAuthHeaderProvider(token: Config.movieAccessToken ?? "")))

        let cache = MovieCoreDataCacheDataSource(controller: .preview)

        let repo = DefaultMovieRepository(network: network, cache: cache)
        MovieListView(repo: repo)
    }
}
