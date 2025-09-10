//
//  DefaultNetworkClient.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

import Foundation

public struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func peform(request: NetworkRequest) async throws -> NetworkResponse {
        let urlRequest = makeURLRequest(from: request)
        do {
            let (data, response) = try await session.data(for: urlRequest)
            return networkResponse(from: data, response: response)

        } catch {
            throw error
        }
    }

    private func networkResponse(from data: Data, response: URLResponse) -> NetworkResponse {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            return .init(statusCode: -1, data: data)
        }

        return .init(statusCode: httpURLResponse.statusCode, data: data)
    }

    private func makeURLRequest(from request: NetworkRequest) -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body

        for (key, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
}
