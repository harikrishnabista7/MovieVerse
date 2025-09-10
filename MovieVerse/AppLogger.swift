//
//  AppLogger.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//


import Foundation
import os

struct AppLogger {
    // MARK: - Subsystem

    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.yourcompany.app"

    // MARK: - Logger instances by category

    private static let networkLogger = Logger(subsystem: subsystem, category: "network")
    private static let uiLogger = Logger(subsystem: subsystem, category: "ui")
    private static let dataLogger = Logger(subsystem: subsystem, category: "data")
    private static let generalLogger = Logger(subsystem: subsystem, category: "general")

    // MARK: - Log Levels

    // Debug logs (development only)
    static func info(_ message: String, category: LogCategory = .general) {
        category.logger.info("\(message)")
    }

    // Notice logs (important info)
    static func notice(_ message: String, category: LogCategory = .general) {
        category.logger.notice("\(message)")
    }

    // Error logs
    static func error(_ message: String, category: LogCategory = .general, error: Error? = nil) {
        if let error = error {
            category.logger.error("\(message) - \(error.localizedDescription)")
        } else {
            category.logger.error("\(message)")
        }
    }

    // Fault logs (critical issues)
    static func fault(_ message: String, category: LogCategory = .general, error: Error? = nil) {
        if let error = error {
            category.logger.fault("\(message) - \(error.localizedDescription)")
        } else {
            category.logger.fault("\(message)")
        }
    }

    // MARK: - Log Categories

    enum LogCategory {
        case network
        case ui
        case data
        case general

        var logger: Logger {
            switch self {
            case .network: return AppLogger.networkLogger
            case .ui: return AppLogger.uiLogger
            case .data: return AppLogger.dataLogger
            case .general: return AppLogger.generalLogger
            }
        }
    }
}
