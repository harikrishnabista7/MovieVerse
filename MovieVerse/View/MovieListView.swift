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
            ForEach(viewModel.movies) { movie in
                NavigationLink {
                    Text("Detail")
                } label: {
                    MovieRowView(movie: movie)
                }
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

