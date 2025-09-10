//
//  NetworkRequestMaker.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//
import Foundation

struct NetworkRequestMaker {
    let authHeaderProvider: AuthHeaderProvider

    func makeFor(endPoint: NetworkEndPoint,
                 method: NetworkRequest.Method = .get,
                 headers: [String: String] = [:],
                 body: Data? = nil) throws -> NetworkRequest {
        let url = try endPoint.makeURL()
        var finalHeaders = headers
        finalHeaders["accept"] = "application/json"
        finalHeaders.merge(authHeaderProvider.authorizationHeaders(), uniquingKeysWith: { $1 })
        return NetworkRequest(url: url, method: method, headers: finalHeaders, body: body)
    }
}
