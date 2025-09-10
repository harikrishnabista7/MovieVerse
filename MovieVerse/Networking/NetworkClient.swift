//
//  NetworkClient.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation

protocol NetworkClient {
    func peform(request: NetworkRequest) async throws -> NetworkResponse
}
