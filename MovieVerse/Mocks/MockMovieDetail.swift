//
//  MockMovieDetail.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//


extension MovieDetail {
    static func mock(id: Int32, title: String = "Interstellar") -> MovieDetail {
        return .init(title: title, id: id, releaseDate: "", posterPath: "", backdropPath: "", rating: 0, runtime: 0, overview: "Interstellar", genres: [])
    }
}
