//
//  Config.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

import Foundation

struct Config {
    struct Keys {
        static let accessToken = "MOVIE_DB_TOKEN"
        static let baseURL = "BASE_URL"
        static let apiKey = "MOVIE_API_KEY"
    }

    private static let infoDictionary = Bundle.main.infoDictionary

    static var movieAccessToken: String? {
        infoDictionary?[Keys.accessToken] as? String
    }

    static var baseURL: String {
        guard let key = infoDictionary?[Keys.baseURL] as? String, !key.isEmpty else {
            fatalError("BASE_URL is missing in Info.plist")
        }
        return key
    }

    static var movieAPIKey: String? {
        infoDictionary?[Keys.apiKey] as? String
    }
}
