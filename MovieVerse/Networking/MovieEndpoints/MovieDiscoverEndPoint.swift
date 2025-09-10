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

