//
//  NetworkResponse.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation

/// Model representing the response from network
struct NetworkResponse {
    /// Status code of the network response
    let statusCode: Int

    /// Data returned in the response body
    let data: Data?
}

extension NetworkResponse {
    func decode<T: Decodable>(type: T.Type) throws -> T {
        guard (200 ... 299).contains(statusCode), let data else {
            throw AppError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
