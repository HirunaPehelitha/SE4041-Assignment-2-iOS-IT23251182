//
//  GenreTag.swift
//  BookNest
//
//  A small label showing the genre that the Core ML model predicted for a book.
//

import SwiftUI

struct GenreTag: View {
    let genre: String

    var body: some View {
        if !genre.isEmpty {
            Label(genre, systemImage: GenreClassifier.icon(for: genre))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.tint)
                .labelStyle(.titleAndIcon)
                .accessibilityLabel("Genre: \(genre)")
        }
    }
}

#Preview {
    VStack {
        GenreTag(genre: "Nature")
        GenreTag(genre: "Mystery")
    }
}
