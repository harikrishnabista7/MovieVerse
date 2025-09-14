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
        List {
            Picker("", selection: $viewModel.selectedMode) {
                ForEach(MovieListMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)

            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .accessibilityIdentifier("progressView")
                    Spacer()
                }
            } else if viewModel.error != nil {
                Text(viewModel.error!)
                    .accessibilityIdentifier("errorText")
            }

            movieRows
        }
        .accessibilityIdentifier("movieList")

        .searchable(text: $viewModel.searchText)
        .navigationTitle(Text(verbatim: .movieVerse))
        .task {
            await viewModel.loadMovies()
        }
    }

    private var movieRows: some View {
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
