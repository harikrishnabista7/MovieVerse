//
//  AuthHeaderProvider.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//


protocol AuthHeaderProvider {
    func authorizationHeaders() -> [String: String]
}
