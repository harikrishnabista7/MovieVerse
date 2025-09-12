//
//  MovieDetailView.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//

import SwiftUI

struct MovieDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 10) {
                AsyncImageView(url: URL(string: "https://fastly.picsum.photos/id/17/2500/1667.jpg?hmac=HD-JrnNUZjFiP2UZQvWcKrgLoC_pc_ouUSWv8kHsJJY"), contentMode: .fit, loadingView: {
                    Color.gray.padding(0.2)
                }, placeholderView: {
                    Color.gray.padding(0.2)
                }, imageLoader: KingfisherImageLoader())
                    .overlay(alignment: .bottomTrailing) {
                        HStack(spacing: 5) {
                            Image(systemName: "star")
                            Text("4.3")
                        }
                        .foregroundStyle(.orange)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(8)
                    }
                    .overlay(alignment: .bottom) {
                        HStack(alignment: .bottom, spacing: 15) {
                            Color.red
                                .frame(width: 95, height: 120)
                                .cornerRadius(16)

                            Text("Spider-Man: No Way Home, Spider-Man: No Way HomeSpider-Man: No Way HomeSpider-Man: No Way HomeSpider-Man: No Way Home")
                                .lineLimit(2)
                                .bold()
                        }
                        .offset(y: 60)
                        .padding(.trailing)
                        .padding(.leading, 10)
                    }

                Spacer(minLength: 70)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        Label("2025", systemImage: "calendar")
                        Text("|")
                        Label("120 min", systemImage: "clock")
                        Text("|")
                        Label("Action", systemImage: "tag")
                        Spacer()
                    }
                    .padding(.bottom)
                    Text("About Movie")
                        .bold()
                    Text("Paranormal investigators Ed and Lorraine Warren take on one last terrifying case involving mysterious entities they must confront.")
                }
                .padding(.leading, 10)
            }
        }
    }
}

#Preview {
    MovieDetailView()
        .preferredColorScheme(.dark)
}
