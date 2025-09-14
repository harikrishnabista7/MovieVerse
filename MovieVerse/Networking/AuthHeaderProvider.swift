//
//  AuthHeaderProvider.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//

/// Header provider for attaching to the url request
protocol AuthHeaderProvider {
    func authorizationHeaders() -> [String: String]
}
