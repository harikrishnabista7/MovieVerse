//
//  MovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation

enum MovieRepositoryError: Error {
    case networkError
}

protocol MovieRepository {
    func getMovies() -> AsyncThrowingStream<[Movie], Error>
    func searchMovies(query: String) async throws -> [Movie]
    func getMovieDetails(id: Int) async throws -> MovieDetail
}












