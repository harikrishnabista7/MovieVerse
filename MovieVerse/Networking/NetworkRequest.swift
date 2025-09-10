//
//  NetworkRequest.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//
import Foundation

/// Model that contains necessary properties for network request
struct NetworkRequest {
    ///
    /// Request's URL.
    ///
    public let url: URL

    ///
    /// Method that corresponds to httpMethod
    ///
    public let method: Method

    ///
    /// Headers
    ///
    public let headers: [String: String]

    ///
    /// Body data.
    ///
    public let body: Data?

    ///
    /// Create an HTTP request object.
    ///
    /// - Parameters:
    ///   - url: Request's URL.
    ///   - method: HTTP method.
    ///   - headers: HTTP headers.
    ///   - body: Body data.
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
    /// Enum to represent different NetworkRequest method
    enum Method: String {
        /// Get method equivalent to httpMethod GET
        case get = "GET"

        /// Post method equivalent to httpMethod POST
        case post = "POST"
    }
}
