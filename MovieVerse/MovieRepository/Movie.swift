//
//  Movie.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//
import Foundation

/* {
  "adult": false,
  "backdrop_path": "/iZLqwEwUViJdSkGVjePGhxYzbDb.jpg",
  "genre_ids": [
      878,
      53
  ],
  "id": 755898,
  "original_language": "en",
  "original_title": "War of the Worlds",
  "overview": "Will Radford is a top analyst for Homeland Security who tracks potential threats through a mass surveillance program, until one day an attack by an unknown entity leads him to question whether the government is hiding something from him... and from the rest of the world.",
  "popularity": 601.1375,
  "poster_path": "/yvirUYrva23IudARHn3mMGVxWqM.jpg",
  "release_date": "2025-07-29",
  "title": "War of the Worlds",
  "video": false,
  "vote_average": 4.354,
  "vote_count": 505
 } */

/// A model that represents a movie fetched from the TMDB API.
struct Movie: Decodable, Equatable, Identifiable {
    /// The title of the movie.
    ///
    /// Example: `"War of the Worlds"`
    let title: String

    /// A unique identifier for the movie (as provided by TMDB).
    ///
    /// Example: `755898`
    let id: Int

    /// The official release date of the movie.
    ///
    /// Example: `"2025-07-29"`
    let releaseDate: String

    /// A partial URL path to the movie poster image.
    ///
    /// This path should be appended to TMDB’s base image URL.
    /// Example: `"/yvirUYrva23IudARHn3mMGVxWqM.jpg"`
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case title
        case id
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}

extension Movie {
    func absoluteImageURL(width: Int = 200, path: String) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w\(width)\(path)")
    }

    var releaseYearStr: String {
        let year = releaseDate.split(separator: "-").first ?? ""
        return String(year)
    }
}
