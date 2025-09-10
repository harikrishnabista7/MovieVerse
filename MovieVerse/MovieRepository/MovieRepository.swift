//
//  MovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation

protocol MovieRepository {
    func getMovies() async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
    func getMovieDetails(id: Int) async throws -> MovieDetail
}



