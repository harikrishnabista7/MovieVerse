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

    init() {
        path = .init()
    }

    @ViewBuilder
    func viewFor(_ route: Route) -> some View {
        switch route {
        case .movieList:
            Text("Movie List")
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
