//
//  MovieVerseApp.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import SwiftUI

@main
struct MovieVerseApp: App {
    @State private var appCoordinator: AppCoordinator = .init()
    
    var body: some Scene {
        WindowGroup {
            CoordinatedRootView(root: AppCoordinator.Route.movieList, coordinator: appCoordinator)
        }
    }
}
