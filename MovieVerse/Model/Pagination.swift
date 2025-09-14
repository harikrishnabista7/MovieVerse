//
//  Pagination.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//


struct Pagination: Decodable {
    let page: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
    }
}