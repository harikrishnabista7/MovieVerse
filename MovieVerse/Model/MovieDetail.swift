//
//  MovieDetail.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//

struct MovieDetail: Decodable, Equatable, Identifiable {
    let title: String
    let id: Int32
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    let rating: Double
    let runtime: Int16
    let overview: String
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case title
        case id
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case rating = "vote_average"
        case runtime
        case overview
        case genres
    }
}

