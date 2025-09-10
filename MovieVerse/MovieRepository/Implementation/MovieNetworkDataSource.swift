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
        let movies = try response.decode(type: [Movie].self)
        return movies
    }

    func searchMovies(query: String) async throws -> [Movie] {
        []
    }

    func getMovieDetails(id: Int) async throws -> MovieDetail {
        .init(title: "", id: 0)
    }
}

enum AppError: Error {
    case decodingError
    case urlError
    case invalidResponse
}

extension NetworkResponse {
    func decode<T: Decodable>(type: T.Type) throws -> T {
        guard (200 ... 299).contains(statusCode), let data else {
            throw AppError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct NetworkRequestMaker {
    let authHeaderProvider: AuthHeaderProvider

    func makeFor(endPoint: NetworkEndPoint,
                 method: NetworkRequest.Method = .get,
                 headers: [String: String] = [:],
                 body: Data? = nil) throws -> NetworkRequest {
        let url = try endPoint.makeURL()
        var finalHeaders = headers
        finalHeaders["accept"] = "application/json"
        finalHeaders.merge(authHeaderProvider.authorizationHeaders(), uniquingKeysWith: { $1 })
        return NetworkRequest(url: url, method: method, headers: finalHeaders, body: body)
    }
}

protocol AuthHeaderProvider {
    func authorizationHeaders() -> [String: String]
}

struct BearerAuthHeaderProvider: AuthHeaderProvider {
    private let token: String

    init(token: String) {
        self.token = token
    }

    func authorizationHeaders() -> [String: String] {
        return ["Authorization": "Bearer \(token)"]
    }
}

struct MovieDiscoverEndPoint: NetworkEndPoint {
    private let page: Int

    init(page: Int = 1) {
        self.page = page
    }

    func makeURL() throws -> URL {
        let path = Constants.baseURLString + "/discover/movie"
        guard let url = URL(string: path),
              var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            throw AppError.urlError
        }

        components.queryItems = [
            URLQueryItem(name: Constants.MovieQueryItem.page.rawValue, value: "\(page)"),
        ]
        return components.url ?? url
    }
}

protocol NetworkEndPoint {
    func makeURL() throws -> URL
}
