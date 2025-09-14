//
//  MovieDetailView.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    init(movieId: Int32, repo: MovieRepository) {
        _viewModel = StateObject(wrappedValue: .init(movieId: movieId, movieRepo: repo))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let movieDetail = viewModel.detail {
                contentView(movieDetail: movieDetail)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button {
                                viewModel.toggleFavorite()
                            } label: {
                                let name = viewModel.isFavorite ? "bookmark.fill" : "bookmark"
                                Image(systemName: name)
                            }

                        }
                    }
            } else if viewModel.error != nil {
                Text(viewModel.error!)

            } else {
                Color.clear
            }
        }
        .task {
            await viewModel.getMovieDetail()
        }
    }

    @ViewBuilder
    private func contentView(movieDetail: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // backdroop
                imageView(url: MovieHelper.absoluteImageURL(size: .w500, path: movieDetail.backdropPath ?? ""),
                          contentMode: .fill,
                          placeholderHeight: 250)
                    .frame(maxHeight: 300)
                    .clipped()
                    .overlay(alignment: .bottomTrailing) {
                        rating(movieDetail: movieDetail)
                    }
                    .overlay(alignment: .bottomLeading) {
                        HStack(alignment: .top) {
                            posterImageView(movieDetail: movieDetail)

                            titleView(movieDetail: movieDetail)
                                .offset(y: 70)
                        }
                        .offset(y: 60)
                    }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        if !movieDetail.releaseDate.isEmpty {
                            Label(MovieHelper.releaseYearStr(movieDetail.releaseDate), systemImage: SystemName.calender)
                        }

                        Text("|")

                        if movieDetail.runtime > 0 {
                            Label("\(movieDetail.runtime) \(String.min)", systemImage: SystemName.clock)
                        }

                        Text("|")

                        if !movieDetail.genres.isEmpty {
                            Label(movieDetail.genres[0].name, systemImage: SystemName.tag)
                        }

                        Spacer()
                    }
                    .padding(.bottom)

                    if !movieDetail.overview.isEmpty {
                        Text(verbatim: .aboutMovie)
                            .bold()

                        Text(movieDetail.overview)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 90)
            }
        }
    }

    @ViewBuilder
    private func rating(movieDetail: MovieDetail) -> some View {
        HStack(spacing: 5) {
            Image(systemName: SystemName.star)
            Text("\(movieDetail.rating, specifier: "%.1f")")
        }
        .bold()
        .foregroundStyle(.orange)
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(8)
    }

    @ViewBuilder
    private func imageView(url: URL?, contentMode: ContentMode, placeholderHeight: CGFloat) -> some View {
        AsyncImageView(url: url, contentMode: contentMode, loadingView: {
            Color.gray.padding(0.2)
                .frame(height: placeholderHeight)
                .opacityShimmer()
        }, placeholderView: {
            Color.gray.padding(0.2).frame(height: placeholderHeight)
        }, imageLoader: KingfisherImageLoader())
    }

    @ViewBuilder
    private func posterImageView(movieDetail: MovieDetail) -> some View {
        imageView(url: MovieHelper.absoluteImageURL(size: .w200, path: movieDetail.posterPath ?? ""),
                  contentMode: .fill, placeholderHeight: 120)
            .frame(width: 95, height: 120)
            .cornerRadius(16)
            .padding(.leading)
    }

    @ViewBuilder
    private func titleView(movieDetail: MovieDetail) -> some View {
        Text(movieDetail.title)
            .lineLimit(2)
            .bold()
            .padding(.trailing)
    }
}
