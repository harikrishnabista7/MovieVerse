//
//  Mock.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//


extension Movie {
    static func mock(id: Int32, title: String = "Interstellar") -> Movie {
        return Movie(title: title, id: id, releaseDate: "", posterPath: "", popularity: 100)
    }
}
