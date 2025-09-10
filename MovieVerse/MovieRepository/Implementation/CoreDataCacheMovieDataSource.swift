//
//  CoreDataCacheMovieDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//


struct CoreDataCacheMovieDataSource: MovieDataSource {
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
