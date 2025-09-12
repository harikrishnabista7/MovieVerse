//
//  MovieSearchEndPoint.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import Foundation

struct MovieSearchEndPoint: NetworkEndPoint {
    private let page: Int
    private let query: String

    init(page: Int = 1, query: String) {
        self.page = page
        self.query = query
    }

    func makeURL() throws -> URL {
        let path = Config.baseURL + "search/movie"
        guard let url = URL(string: path),
              var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            throw AppError.urlError
        }

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: Constants.MovieQueryItem.page.rawValue, value: "\(page)"),
            URLQueryItem(name: Constants.MovieQueryItem.query.rawValue, value: query)
        ]

        if let apiKey = Config.movieAPIKey, !apiKey.isEmpty {
            queryItems.append(.init(name: Constants.MovieQueryItem.apiKey.rawValue, value: apiKey))
        }

        components.queryItems = queryItems
        return components.url ?? url
    }
}
