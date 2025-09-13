//
//  MockMovieDetail.swift
//  MovieVerseTests
//
//  Created by hari krishna on 11/09/2025.
//

import Foundation
@testable import MovieVerse

extension MovieDetail {
    static func mock(id: Int32, title: String = "Interstellar") -> MovieDetail {
        return .init(title: title, id: id, releaseDate: "", posterPath: "", backdropPath: "", rating: 0, runtime: 0, overview: "", genres: [])
    }
}
