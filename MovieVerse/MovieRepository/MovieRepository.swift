//
//  MovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation

/// Errors that can occur while interacting with the movie repository.
enum MovieRepositoryError: Error {
    /// Indicates a failure caused by network connectivity or request issues.
    case networkError
}

/// A repository abstraction for managing movie data.
///
/// The `MovieRepository` coordinates between different data sources
/// (such as **remote APIs** and **local caches**) to provide movies
/// to higher-level layers like the ViewModel or UI.
///
protocol MovieRepository {
    /// Provides a stream of movies.
    ///
    /// This allows consumers to receive cached data immediately, followed by
    /// updated data when it becomes available (e.g., from the network).
    ///
    /// - Returns: An `AsyncThrowingStream` that yields arrays of `Movie` objects.
    ///            The stream may yield multiple values (cache + network).
    /// - Throws: If the underlying data retrieval fails, the stream terminates with an error.
    func getMovies() -> AsyncThrowingStream<[Movie], Error>

    /// Searches for movies that match the given query string.
    ///
    /// - Parameter query: The search text (e.g., a title or keyword).
    /// - Returns: An array of `Movie` objects matching the query.
    /// - Throws: A `MovieRepositoryError` or another error if the search fails.
    func searchMovies(query: String) async throws -> [Movie]

    /// Retrieves detailed information about a specific movie.
    ///
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: A `MovieDetail` object containing full information about the movie.
    /// - Throws: A `MovieRepositoryError` or another error if retrieval fails.
    func getMovieDetails(id: Int) async throws -> MovieDetail
}
