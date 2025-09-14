//
//  MovieDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

/// A protocol that defines the contract for fetching movie-related data.
///
/// Conforming types can represent different data sources, such as a **remote API**,
/// a **local cache**, or a **mock implementation** for testing.
///
/// This protocol focuses only on **retrieving** movies and their details,
/// without defining how they are persisted.
protocol MovieDataSource {
    /// Fetches a list of movies.
    ///
    /// - Returns: An array of `Movie` objects.
    /// - Throws: An error if the data could not be retrieved.
    /// - Note: The data source determines whether the movies are loaded from
    ///   cache, network, or another storage mechanism.
    func getMovies() async throws -> [Movie]

    /// Searches for movies that match the given query.
    ///
    /// - Parameter query: The search text, typically a movie title or keyword.
    /// - Returns: An array of `Movie` objects matching the search term.
    /// - Throws: An error if the search request fails.
    func searchMovies(query: String) async throws -> [Movie]

    /// Retrieves detailed information for a specific movie.
    ///
    /// - Parameter id: The unique identifier of the movie (as provided by the data source).
    /// - Returns: A `MovieDetail` object containing extended movie information.
    /// - Throws: An error if the movie details could not be retrieved.
    func getMovieDetail(id: Int32) async throws -> MovieDetail

    /// Loads the next page of movies, optionally filtered by a search query.
    ///
    /// - Parameters:
    ///   - searchQuery: Optional search text to filter movies.
    ///   - after: The ID of the last movie from the previous page (or nil for first page).
    /// - Returns: A list of movies for the next page.
    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie]
}
