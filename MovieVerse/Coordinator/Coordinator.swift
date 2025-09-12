//
//  Coordinator.swift
//  MovieVerse
//
//  Created by hari krishna on 12/09/2025.
//

import Combine
import SwiftUI

typealias CoordinatorRoute = Hashable & Identifiable

@MainActor
protocol Coordinator: ObservableObject {
    associatedtype Route: CoordinatorRoute
    associatedtype V: View

    /// Navigation stack path
    var path: NavigationPath { get set }

    /// Currently presented sheet route
    var presentedSheet: Route? { get set }

    /// Currently presented full-screen route
    var presentedFullScreen: Route? { get set }

    /// Given a route, return the associated view
    @ViewBuilder func viewFor(_ route: Route) -> V
}

extension Coordinator {
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        if path.count > 1 {
            path.removeLast()
        }
    }

    func popToRoot() {
        if path.count > 1 {
            path.removeLast(path.count - 1)
        }
    }

    func presentSheet(_ route: Route) {
        presentedSheet = route
    }

    func presentFullScreen(_ route: Route) {
        presentedFullScreen = route
    }

    func dismissAll() {
        presentedSheet = nil
        presentedFullScreen = nil
    }
}
