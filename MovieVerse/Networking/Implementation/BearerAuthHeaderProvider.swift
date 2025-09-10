//
//  BearerAuthHeaderProvider.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//


struct BearerAuthHeaderProvider: AuthHeaderProvider {
    private let token: String

    init(token: String) {
        self.token = token
    }

    func authorizationHeaders() -> [String: String] {
        return ["Authorization": "Bearer \(token)"]
    }
}
