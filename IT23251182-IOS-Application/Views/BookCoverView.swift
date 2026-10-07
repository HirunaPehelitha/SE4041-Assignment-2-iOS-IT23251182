//
//  BookCoverView.swift
//  BookNest
//
//  CUSTOM COMPONENT: draws a book cover from the title, author and a colour.
//  No images are needed, so every book gets a cover automatically.
//

import SwiftUI

struct BookCoverView: View {
    let title: String
    let author: String
    let hue: Double
    var progress: Double = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // The cover: a gradient with a darker "spine" on the left.
            LinearGradient(
                colors: [Color(hue: hue, saturation: 0.55, brightness: 0.75),
                         Color(hue: hue, saturation: 0.75, brightness: 0.45)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(alignment: .leading) {
                Rectangle().fill(.black.opacity(0.2)).frame(width: 8)
            }

            VStack(spacing: 6) {
                Spacer()
                Text(title)
                    .font(.system(.headline, design: .serif))
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .minimumScaleFactor(0.7)
                Text(author)
                    .font(.caption)
                    .opacity(0.85)
                    .lineLimit(1)
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(12)

            // Reading progress bar along the bottom of the cover.
            if progress > 0 {
                GeometryReader { geo in
                    Rectangle()
                        .fill(.white)
                        .frame(width: geo.size.width * progress, height: 4)
                }
                .frame(height: 4)
            }
        }
        .aspectRatio(2 / 3, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 8))
        .shadow(color: .black.opacity(0.25), radius: 6, x: 2, y: 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) by \(author)")
        .accessibilityValue(progress > 0 ? "\(Int(progress * 100)) percent read" : "Not started")
    }
}

#Preview {
    BookCoverView(title: "The Kite Over Galle Fort", author: "BookNest", hue: 0.58, progress: 0.4)
        .frame(width: 140)
        .padding()
}
