//
//  AppCoordinator.swift
//  MovieVerse
//
//  Created by hari krishna on 12/09/2025.
//

import SwiftUI

final class AppCoordinator: Coordinator {
    enum AppCoordinatorRoute: CoordinatorRoute {
        var id: Self { self }

        case movieList
        case movieDetail(Int32)
    }

    @Published var path: NavigationPath
    @Published var presentedSheet: Route?
    @Published var presentedFullScreen: Route?

    typealias Route = AppCoordinatorRoute

    private let repo: MovieRepository

    init() {
        path = .init()

        let network = MovieNetworkDataSource(
            client: DefaultNetworkClient(),
            requestMaker: NetworkRequestMaker(authHeaderProvider: BearerAuthHeaderProvider(token: Config.movieAccessToken ?? "")))

        let cache = MovieCoreDataCacheDataSource(controller: .shared)
        let env = ProcessInfo.processInfo.environment
        
//        if env["MOCK_MOVIE_ERROR"] == "true" {
//            repo = MockMovieNetworkDataSource(scenario: .error(URLError(.badURL)))
//        } else if env["MOCK_MOVIE_SUCCESS"] == "true" {
//            
//        } else if env["MOCK_MOVIE_DETAIL"] == "true" {
//            
//        } else {
            repo = DefaultMovieRepository(network: network, cache: cache)
//        }
    }

    @ViewBuilder
    func viewFor(_ route: Route) -> some View {
        switch route {
        case .movieList:
            MovieListView(repo: repo)
        case .movieDetail(let movieId):
            MovieDetailView(movieId: movieId, repo: repo)
        }
    }

    private func handleNavigation(_ route: Route) {
        switch route {
        case .movieList:
            popToRoot()
        default:
            push(route)
        }
    }
}
