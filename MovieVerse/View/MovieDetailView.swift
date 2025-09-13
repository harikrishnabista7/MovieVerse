//
//  MovieDetailView.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import SwiftUI

struct MovieDetailView: View {
    let movieDetail: MovieDetail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // backdroop
                imageView(url: MovieHelper.absoluteImageURL(size: .w500, path: movieDetail.backdropPath), contentMode: .fill)
                    .frame(maxHeight: 300)
                    .clipped()
                    .overlay(alignment: .bottomTrailing) {
                        rating
                    }
                    .overlay(alignment: .bottomLeading) {
                        HStack(alignment: .top) {
                            posterImage

                            title
                                .offset(y: 70)
                        }
                        .offset(y: 60)
                    }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        Label(MovieHelper.releaseYearStr(movieDetail.releaseDate), systemImage: "calendar")
                        Text("|")
                        Label("\(movieDetail.runtime) min", systemImage: "clock")

                        if !movieDetail.genres.isEmpty {
                            Text("|")
                            Label(movieDetail.genres[0].name, systemImage: "tag")
                        }

                        Spacer()
                    }
                    .padding(.bottom)

                    Text("About Movie")
                        .bold()
                    Text(movieDetail.overview)
                }
                .padding(.horizontal)
                .padding(.top, 90)
            }
        }
    }

    var overView: some View {
        Text(movieDetail.overview)
            .lineLimit(2)
            .bold()
    }

    var rating: some View {
        HStack(spacing: 5) {
            Image(systemName: "star")
            Text("\(movieDetail.rating, specifier: "%.1f")")
        }
        .foregroundStyle(.orange)
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(8)
    }

    @ViewBuilder
    func imageView(url: URL?, contentMode: ContentMode) -> some View {
        AsyncImageView(url: url, contentMode: contentMode, loadingView: {
            Color.gray.padding(0.2)
        }, placeholderView: {
            Color.gray.padding(0.2)
        }, imageLoader: KingfisherImageLoader())
    }

    var posterImage: some View {
        imageView(url: MovieHelper.absoluteImageURL(size: .w200, path: movieDetail.posterPath),
                  contentMode: .fill)
            .frame(width: 95, height: 120)
            .cornerRadius(16)
            .padding(.leading)
    }

    var title: some View {
        Text(movieDetail.title)
            .lineLimit(2)
            .bold()
            .padding(.trailing)
    }
}

#Preview {
    let detail: MovieDetail = .init(title: "The Conjuring: Last Rites", id: 1, releaseDate: "2024-01-01", posterPath: "/kOzwIr0R7WhaFgoYUZFLPZA2RBZ.jpg", backdropPath: "/kOzwIr0R7WhaFgoYUZFLPZA2RBZ.jpg", rating: 6.58, runtime: 135, overview: "In 1520, the notorious and power-hungry Danish King Christian II is determined to seize the Swedish crown from Sten Sture, no matter what it takes. Meanwhile, sisters Freja and Anne make a solemn promise to seek revenge on the men who brutally murdered their family. Everything comes to a head in the heart of Stockholm, where the sisters are drawn into a ruthless political struggle between Sweden and Denmark that culminates in a mass execution, presided over by the mad King \"Christian the Tyrant,\" known as the Stockholm Bloodbath.", genres: [
        .init(id: 1, name: "Action"),
        // .init(id: 1, name: "Documentary")
    ])
    MovieDetailView(movieDetail: detail)
}
