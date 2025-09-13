//
//  MovieDetailEndPoint.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import Foundation

struct MovieDetailEndPoint: NetworkEndPoint {
    let movieId: Int32

    init(movieId: Int32) {
        self.movieId = movieId
    }

    func makeURL() throws -> URL {
        let path = Config.baseURL + "movie/\(movieId)"
        guard let url = URL(string: path),
              var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            throw AppError.urlError
        }

        var queryItems: [URLQueryItem] = []

        if let apiKey = Config.movieAPIKey, !apiKey.isEmpty {
            queryItems.append(.init(name: Constants.MovieQueryItem.apiKey.rawValue, value: apiKey))
        }

        components.queryItems = queryItems
        return components.url ?? url
    }
}
