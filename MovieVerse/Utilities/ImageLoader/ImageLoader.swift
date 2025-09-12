//
//  ImageLoader.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//


// MARK: - Protocol for Image Loading
import UIKit

protocol ImageLoader {
    func loadImage(from url: URL) async throws -> UIImage
}
