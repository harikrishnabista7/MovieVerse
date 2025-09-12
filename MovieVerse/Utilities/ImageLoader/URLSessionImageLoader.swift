//
//  URLSessionImageLoader.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import UIKit

class URLSessionImageLoader: ImageLoader {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await session.data(from: url)
        return UIImage(data: data)!
    }
}
