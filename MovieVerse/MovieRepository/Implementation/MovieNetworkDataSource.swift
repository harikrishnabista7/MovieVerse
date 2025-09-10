//
//  MovieNetworkDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

struct MovieNetworkDataSource: MovieDataSource {
    let client: NetworkClient

    func getMovies() -> [Movie] {
        return []
    }

    func searchMovies(query: String) -> [Movie] {
        return []
    }

    func getMovieDetails(id: Int) -> MovieDetail {
        .init(title: "", id: 0)
    }
}
