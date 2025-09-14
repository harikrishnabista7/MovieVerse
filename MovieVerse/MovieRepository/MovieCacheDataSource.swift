//
//  MovieCacheDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

/// A data source protocol responsible for caching movie-related data locally.
///
/// `MovieCacheDataSource` extends the base `MovieDataSource` protocol, and adds
/// methods to persist movies and movie details into a local storage mechanism,
/// such as a database or file system.
///
/// Conforming types are expected to implement both retrieval (from `MovieDataSource`)
/// and saving (from this protocol) of movie information.
protocol MovieCacheDataSource: MovieDataSource {
    /// Saves a collection of movies to the cache.
    ///
    /// - Parameter movies: An array of `Movie` objects to be stored.
    /// - Throws: An error if saving to the cache fails.
    /// - Note: This operation is asynchronous.
    func saveMovies(_ movies: [Movie]) async throws

    /// Saves the detailed information of a single movie to the cache.
    ///
    /// - Parameter detail: A `MovieDetail` object containing extended movie information.
    /// - Throws: An error if saving to the cache fails.
    /// - Note: This operation is asynchronous.
    func saveMovieDetail(_ detail: MovieDetail) async throws
    
    /// Checks if the movie is in favorite list or not
    /// - Parameter movieId: id: The unique identifier of the movie.
    /// - Returns: Bool, true for isFavorite otherwise false
    func isFavoriteMovie(_ movieId: Int32) async throws -> Bool
}
