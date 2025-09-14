//
//  MovieNetworkDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//
import Foundation

struct Pagination: Decodable {
    let page: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
    }
}

final class MovieNetworkDataSource: MovieDataSource {
    let client: NetworkClient
    let requestMaker: NetworkRequestMaker
    //   let loadPagination:
    private var moviesPagination: Pagination?
    private var searchPagination: Pagination?

    init(client: NetworkClient, requestMaker: NetworkRequestMaker) {
        self.client = client
        self.requestMaker = requestMaker
    }

    func getMovies() async throws -> [Movie] {
        try await loadMoviesPage(page: 1)
    }

    func searchMovies(query: String) async throws -> [Movie] {
        try await loadSearchMoviesPage(page: 1, query: query)
    }

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
        let request = try requestMaker.makeFor(endPoint: MovieDetailEndPoint(movieId: id))
        let response = try await client.perform(request: request)
        let detail = try response.decode(type: MovieDetail.self)
        return detail
    }

    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie] {
        if let searchQuery, let searchPagination {
            return try await loadSearchMoviesPage(page: searchPagination.page + 1, query: searchQuery)
        } else if let moviesPagination {
            return try await loadMoviesPage(page: moviesPagination.page + 1)
        }

        throw AppError.notFound
    }

    private func loadSearchMoviesPage(page: Int, query: String) async throws -> [Movie] {
        let request = try requestMaker.makeFor(endPoint: MovieSearchEndPoint(page: page, query: query))
        let response = try await client.perform(request: request)
        if let pagination = try? response.decode(type: Pagination.self) {
            searchPagination = pagination
        }
        let movies = try response.decode(type: [Movie].self, dictionaryKey: "results")
        return movies
    }

    private func loadMoviesPage(page: Int) async throws -> [Movie] {
        let request = try requestMaker.makeFor(endPoint: MovieDiscoverEndPoint(page: page))
        let response = try await client.perform(request: request)
        if let pagination = try? response.decode(type: Pagination.self) {
            moviesPagination = pagination
        }
        let movies = try response.decode(type: [Movie].self, dictionaryKey: "results")
        return movies
    }
}
