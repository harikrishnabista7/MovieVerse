//
//  NetworkEndPoint.swift
//  MovieVerse
//
//  Created by hari krishna on 11/09/2025.
//
import Foundation

protocol NetworkEndPoint {
    func makeURL() throws -> URL
}
