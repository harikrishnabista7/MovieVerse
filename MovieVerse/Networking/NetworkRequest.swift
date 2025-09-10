//
//  NetworkRequest.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//
import Foundation

struct NetworkRequest {
    let url: URL

    let method: Method

    let headers: [String: String]

    let body: Data?

    init(url: URL,
         method: Method = .get,
         headers: [String: String] = [:],
         body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
}

extension NetworkRequest {
    enum Method: String {
        case get = "GET"

        case post = "POST"
    }
}
