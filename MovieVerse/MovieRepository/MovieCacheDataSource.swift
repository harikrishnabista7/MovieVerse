//
//  MovieCacheDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//


protocol MovieCacheDataSource: MovieDataSource {
    func saveMovies(_ movies: [Movie]) async throws
    func saveMovieDetail(_ detail: MovieDetail) async throws
}