//
//  AsyncImageView.swift
//  MovieVerse
//
//  Created by hari krishna on 13/09/2025.
//
import SwiftUI

struct AsyncImageView<LoadingView: View, PlaceholderView: View>: View {
    let url: URL?
    let contentMode: ContentMode

    @ViewBuilder var loadingView: () -> LoadingView
    @ViewBuilder var placeholderView: () -> PlaceholderView

    let imageLoader: ImageLoader

    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(url: URL?, contentMode: ContentMode = .fit, @ViewBuilder loadingView: @escaping () -> LoadingView, @ViewBuilder placeholderView: @escaping () -> PlaceholderView, imageLoader: ImageLoader) {
        self.url = url
        self.contentMode = contentMode
        self.loadingView = loadingView
        self.placeholderView = placeholderView
        self.imageLoader = imageLoader
       
    }
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                loadingView()
            } else {
                placeholderView()
            }
        }
        .task {
            if let url {
                do {
                    isLoading = true
                    image = try await imageLoader.loadImage(from: url)
                } catch {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    AsyncImageView(url: URL(string: "https://picsum.photos/500"), contentMode: .fill, loadingView: {
        ProgressView()
    }, placeholderView: {
        Color.gray.opacity(0.2)
    }, imageLoader: URLSessionImageLoader())
}
