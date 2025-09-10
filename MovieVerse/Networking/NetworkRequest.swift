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
}

extension NetworkRequest {
    enum Method: String {
        case get = "GET"

        case post = "POST"
    }
}
