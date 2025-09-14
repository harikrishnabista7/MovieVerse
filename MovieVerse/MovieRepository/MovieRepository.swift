//
//  MovieRepository.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation


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
    /// - Throws: An error if the search request fails.
    func searchMovies(query: String) async throws -> [Movie]

    /// Retrieves detailed information about a specific movie.
    ///
    /// - Parameter id: The unique identifier of the movie.
    /// - Returns: A `MovieDetail` object containing full information about the movie.
    /// - Throws: An error  if retrieval fails.
    func getMovieDetail(id: Int32) async throws -> MovieDetail

    /// Loads the next page of movies, optionally filtered by a search query.
    ///
    /// - Parameters:
    ///   - searchQuery: Optional search text to filter movies.
    ///   - after: The ID of the last movie from the previous page (or nil for first page).
    /// - Returns: A list of movies for the next page.
    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie]
    
    
    /// Adds movie to favorites list
    /// - Parameter movieId: id: The unique identifier of the movie.
    func addMovieToFavorites(_ movieId: Int32) async throws
    
    
    /// Removes movie from favorites list
    /// - Parameter movieId: id: The unique identifier of the movie.
    func removeMovieFromFavorites(_ movieId: Int32) async throws
    
    
    /// Checks if the movie is in favorite list or not
    /// - Parameter movieId: id: The unique identifier of the movie.
    /// - Returns: Bool, true for isFavorite otherwise false
    func isFavoriteMovie(_ movieId: Int32) async throws -> Bool
    
    /// Returns favorite movies from list
    /// - Returns: movies: An array of `Movie` objects
    func favoriteMovies(query: String) async throws -> [Movie]
    
}
