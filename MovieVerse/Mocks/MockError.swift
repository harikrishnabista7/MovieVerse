//
//  MockError.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//
import Foundation

struct MockError: LocalizedError {
    let errormessage: String

    init(errorMessage: String) {
        errormessage = errorMessage
    }

    var errorDescription: String? {
        return errormessage
    }
}
