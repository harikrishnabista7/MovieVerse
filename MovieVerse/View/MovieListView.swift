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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    MovieListView()
//}
