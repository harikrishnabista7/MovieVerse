//
//  File.swift
//  MovieVerseTests
//
//  Created by hari krishna on 11/09/2025.
//

import Foundation
@testable import MovieVerse

extension Movie {
    static func mock(id: Int, title: String = "Interstellar") -> Movie {
        return Movie(title: title, id: id, releaseDate: .distantPast, posterPath: "", overview: "")
    }
}
