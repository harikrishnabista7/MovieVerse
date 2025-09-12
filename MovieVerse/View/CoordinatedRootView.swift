//
//  CoordinatedRootView.swift
//  MovieVerse
//
//  Created by hari krishna on 12/09/2025.
//

import SwiftUI

struct CoordinatedRootView<C: Coordinator>: View {
    let root: C.Route
    @ObservedObject var coordinator: C

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.viewFor(root)
                .navigationDestination(for: C.Route.self) { route in
                    coordinator.viewFor(route)
                }
                .sheet(item: $coordinator.presentedSheet) { route in
                    coordinator.viewFor(route)
                }
                .fullScreenCover(item: $coordinator.presentedFullScreen) { route in
                    coordinator.viewFor(route)
                }
        }
    }
}
