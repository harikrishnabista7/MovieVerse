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
        print(env)

       // #if DEBUG
            if let scenario = env["MOCK_SCENARIO"] {
                let delay = Double(env["MOCK_DELAY"] ?? "0.1") ?? 0.1
                switch scenario {
                case "error":
                    repo = MockMovieRepository(scenario: .error(URLError(.badURL)), excludeCacheSimulation: true, delay: delay)
                case "success":
                    repo = MockMovieRepository(scenario: .movies([Movie.mock(id: 1)]), excludeCacheSimulation: true, delay: delay)
                case "favorites":
                    repo = MockMovieRepository(scenario: .favorites([Movie.mock(id: 1)]), excludeCacheSimulation: true, delay: delay)
                case "successWithDetail":
                    repo = MockMovieRepository(scenario: .movieWithDetail(.mock(id: 1), .mock(id: 1)), excludeCacheSimulation: true, delay: delay)
                case "detail":
                    repo = MockMovieRepository(scenario: .detail(MovieDetail.mock(id: 1)), excludeCacheSimulation: true, delay: delay)
                default:
                    repo = DefaultMovieRepository(network: network, cache: cache)
                }
            } else {
                repo = DefaultMovieRepository(network: network, cache: cache)
            }
//        #else
//            repo = DefaultMovieRepository(network: network, cache: cache)
//        #endif
    }

    @ViewBuilder
    func viewFor(_ route: Route) -> some View {
        switch route {
        case .movieList:
            MovieListView(repo: repo)
        case let .movieDetail(movieId):
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
