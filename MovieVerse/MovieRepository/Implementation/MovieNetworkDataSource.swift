//
//  MovieNetworkDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//
import Foundation

struct MovieNetworkDataSource: MovieDataSource {
    let client: NetworkClient
    let requestMaker: NetworkRequestMaker

    init(client: NetworkClient, requestMaker: NetworkRequestMaker) {
        self.client = client
        self.requestMaker = requestMaker
    }

    func getMovies() async throws -> [Movie] {
        let request = try requestMaker.makeFor(endPoint: MovieDiscoverEndPoint())
        let response = try await client.perform(request: request)
        let movies = try response.decode(type: [Movie].self, dictionaryKey: "results")
        return movies
    }

    func searchMovies(query: String) async throws -> [Movie] {
        let request = try requestMaker.makeFor(endPoint: MovieSearchEndPoint(query: query))
        let response = try await client.perform(request: request)
        let movies = try response.decode(type: [Movie].self, dictionaryKey: "results")
        return movies
    }

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
        let request = try requestMaker.makeFor(endPoint: MovieDetailEndPoint(movieId: id))
        let response = try await client.perform(request: request)
        let detail = try response.decode(type: MovieDetail.self)
        return detail
    }
}
