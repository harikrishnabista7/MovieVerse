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
    func decode<T: Decodable>(type: T.Type, dictionaryKey: String? = nil) throws -> T {
        guard (200 ... 299).contains(statusCode), var data else {
            throw AppError.invalidResponse
        }

        if let dictionaryKey = dictionaryKey {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let actualDictionary = jsonObject?[dictionaryKey]
            data = try JSONSerialization.data(withJSONObject: actualDictionary ?? [:], options: [])
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
