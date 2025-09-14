//
//  AppError.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//
import Foundation

enum AppError: LocalizedError {
    case decodingError
    case urlError
    case invalidResponse
    case invalidURL
    case imageLoadingError
    case notFound
    case authenticationFailed
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Decoding Error"
        case .urlError:
            return "URL Error"
        case .invalidResponse:
            return "Invalid Response"
        case .invalidURL:
            return "Invalid URL"
        case .imageLoadingError:
            return "Image Loading Error"
        case .notFound:
            return "Not Found"
        case .authenticationFailed:
            return "Authentication Failed"
        case let .networkError(message):
            return message
        }
    }
}
