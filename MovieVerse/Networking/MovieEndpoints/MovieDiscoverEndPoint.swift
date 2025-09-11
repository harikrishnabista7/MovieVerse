//
//  MovieDiscoverEndPoint.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

import Foundation

struct MovieDiscoverEndPoint: NetworkEndPoint {
    private let page: Int

    init(page: Int = 1) {
        self.page = page
    }

    func makeURL() throws -> URL {
        let path = Config.baseURL + "discover/movie"
        guard let url = URL(string: path),
              var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            throw AppError.urlError
        }

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: Constants.MovieQueryItem.page.rawValue, value: "\(page)"),
        ]

        if let apiKey = Config.movieAPIKey, !apiKey.isEmpty {
            queryItems.append(.init(name: Constants.MovieQueryItem.apiKey.rawValue, value: apiKey))
        }

        components.queryItems = queryItems
        return components.url ?? url
    }
}
