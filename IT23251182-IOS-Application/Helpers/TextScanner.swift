//
//  TextScanner.swift
//  BookNest
//
//  EMERGING TECH: uses Apple's Vision framework to read printed text from a photo.
//  This lets a user photograph pages of a paper book and turn them into an e-book.
//

import Foundation
import Vision

enum TextScanner {
    /// Returns all the text Vision can find in the image, one line per row of text.
    static func recognizeText(in imageData: Data) async throws -> String {
        var request = RecognizeTextRequest()
        request.recognitionLevel = .accurate      // slower but better for book pages
        request.usesLanguageCorrection = true     // fixes small spelling mistakes

        let observations = try await request.perform(on: imageData)

        // Each observation is one line of text. Take the best guess for each line.
        let lines = observations.compactMap { $0.topCandidates(1).first?.string }
        return lines.joined(separator: "\n")
    }
}
