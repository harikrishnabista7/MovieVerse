//
//  MovieRowView.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            AsyncImageView(url: movie.absoluteImageURL(path: movie.posterPath), contentMode: .fill, loadingView: {
                Color.gray.opacity(0.2)
            }, placeholderView: {
                Color.gray.opacity(0.2)
            }, imageLoader: KingfisherImageLoader())
                .frame(width: 70, height: 70)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .padding(.top, 8)
                    .bold()
                    .lineLimit(2)

                HStack {
                    Image(systemName: "calendar")
                    Text(movie.releaseYearStr)
                }
            }
            .font(.system(size: 15))
        }
    }
}

#Preview {
    MovieRowView(movie:
        .init(title: "The Conjuring: Last Rites", id: 1, releaseDate: "2025", posterPath: "/kOzwIr0R7WhaFgoYUZFLPZA2RBZ.jpg")
    )
}
