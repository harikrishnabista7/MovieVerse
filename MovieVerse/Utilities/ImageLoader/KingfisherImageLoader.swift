//
//  KingfisherImageLoader.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import Kingfisher
import UIKit

struct KingfisherImageLoader: ImageLoader {
    func loadImage(from url: URL) async throws -> UIImage {
        do {
            let result = try await KingfisherManager.shared.retrieveImage(with: url)
            return result.image
        } catch {
            throw AppError.imageLoadingError
        }
    }
}
