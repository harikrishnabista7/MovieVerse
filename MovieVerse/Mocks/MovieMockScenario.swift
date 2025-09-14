//
//  MovieMockScenario.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//

enum MovieMockScenario {
    case movies([Movie])
    case error(Error)
    case detail(MovieDetail)
    case favorites([Movie])
    case movieWithDetail(Movie, MovieDetail)
}
