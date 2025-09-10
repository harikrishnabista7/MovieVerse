//
//  NetworkClient.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation
/// Protocol for making network requests
protocol NetworkClient {
    /// Performs network request
    /// - Parameter request: NetworkRequest
    /// - Returns: NetworkResponse
    func peform(request: NetworkRequest) async throws -> NetworkResponse
}
