//
//  OpacityShimmer.swift
//  MovieVerse
//
//  Created by hari krishna on 14/09/2025.
//
import SwiftUI

// MARK: - Shimmer Modifier

struct OpacityShimmer: ViewModifier {
    let values: [Double]
    let duration: Double
    let easingCurve: Animation

    @State private var currentIndex: Int = 0

    init(values: [Double] = Array(stride(from: 0.2, to: 0.9, by: 0.1)),
         duration: Double = 1.8,
         easing: Animation = .easeInOut) {
        self.values = values
        self.duration = duration
        easingCurve = easing
    }

    func body(content: Content) -> some View {
        content
            .opacity(values[currentIndex])
            .animation(easingCurve, value: currentIndex)
            .onAppear {
                startSteppedAnimation()
            }
    }

    private func startSteppedAnimation() {
        Timer.scheduledTimer(withTimeInterval: duration / Double(values.count), repeats: true) { _ in
            withAnimation(easingCurve) {
                currentIndex = (currentIndex + 1) % values.count
            }
        }
    }
}

extension View {
    func opacityShimmer(values: [Double] = Array(stride(from: 0.2, to: 0.9, by: 0.1)),
                        duration: Double = 1.8,
                        easing: Animation = .easeInOut) -> some View {
        modifier(OpacityShimmer(values: values, duration: duration, easing: easing))
    }
}
