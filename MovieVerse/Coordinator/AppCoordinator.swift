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
        case movieDetail(Int)
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

        repo = DefaultMovieRepository(network: network, cache: cache)
    }

    @ViewBuilder
    func viewFor(_ route: Route) -> some View {
        switch route {
        case .movieList:
            MovieListView(repo: repo)
        case .movieDetail:
            Text("Detail")
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
