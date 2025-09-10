//
//  MovieNetworkDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//
import Foundation

struct MovieNetworkDataSource: MovieDataSource {
    let client: NetworkClient

    func getMovies() -> [Movie] {
        return []
    }

    func searchMovies(query: String) -> [Movie] {
        return []
    }

    func getMovieDetails(id: Int) -> MovieDetail {
        .init(title: "", id: 0)
    }
}

struct NetworkRequestMaker {
    let authHeaderProvider: AuthHeaderProvider
    
    func make(for endPoint: NetworkEndPoint,
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
            throw NSError(domain: "", code: 0, userInfo: nil)
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
