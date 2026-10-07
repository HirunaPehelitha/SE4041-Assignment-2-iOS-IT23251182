//
//  ReadingProgressBar.swift
//  BookNest
//
//  CUSTOM COMPONENT: a rounded progress bar that fills up with an animation.
//  Used on the Library screen and the "Continue Reading" card.
//

import SwiftUI

struct ReadingProgressBar: View {
    let progress: Double          // 0...1
    var height: CGFloat = 6

    // Starts at 0 and animates to the real value when the bar appears.
    @State private var shownProgress: Double = 0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.quaternary)
                Capsule()
                    .fill(progress >= 1 ? AnyShapeStyle(.green) : AnyShapeStyle(Color.accentColor.gradient))
                    .frame(width: geo.size.width * shownProgress)
            }
        }
        .frame(height: height)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) { shownProgress = progress }
        }
        .onChange(of: progress) {
            withAnimation(.easeOut(duration: 0.4)) { shownProgress = progress }
        }
        .accessibilityElement()
        .accessibilityLabel("Reading progress")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}

#Preview {
    VStack(spacing: 20) {
        ReadingProgressBar(progress: 0)
        ReadingProgressBar(progress: 0.45)
        ReadingProgressBar(progress: 1)
    }
    .padding()
}
