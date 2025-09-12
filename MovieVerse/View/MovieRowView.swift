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
            AsyncImage(url: movie.absoluteImageURL(path: movie.posterPath)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }.frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(movie.title)
                    .padding(.top, 8)
                    .bold()

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
