//
//  GenreClassifier.swift
//  BookNest
//
//  EMERGING TECH (main): CORE ML.
//  Uses our own Core ML model, BookGenreClassifier.mlmodel, trained with Create ML
//  (see ML/train_genre_model.swift), to guess a book's genre from its text.
//  Runs on the device – no internet needed.
//

import Foundation
import CoreML
import NaturalLanguage

enum GenreClassifier {

    /// The genres the model was trained on, with an icon for each.
    static let genres = ["Adventure", "Nature", "Family", "Science", "Mystery"]

    static func icon(for genre: String) -> String {
        switch genre {
        case "Adventure": "map.fill"
        case "Nature": "leaf.fill"
        case "Family": "house.fill"
        case "Science": "atom"
        case "Mystery": "magnifyingglass"
        default: "questionmark"
        }
    }

    /// Loads the Core ML model once and wraps it in an NLModel (NaturalLanguage handles the text for us).
    /// Xcode compiles BookGenreClassifier.mlmodel into "BookGenreClassifier.mlmodelc" inside the app.
    private static let model: NLModel? = {
        guard let url = Bundle.main.url(forResource: "BookGenreClassifier", withExtension: "mlmodelc"),
              let coreMLModel = try? MLModel(contentsOf: url) else {
            return nil
        }
        return try? NLModel(mlModel: coreMLModel)
    }()

    /// Returns the most likely genre and how sure the model is (0...1), or nil if the text is empty.
    ///
    /// The model was trained on single sentences, so we ask it about each sentence separately
    /// and add up the probabilities. The genre with the most "evidence" across the text wins.
    static func predict(_ text: String) -> (genre: String, confidence: Double)? {
        guard let model else { return nil }

        // 1. Split the text into sentences (the first 40 are enough, and it keeps it fast).
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        let sentences = tokenizer.tokens(for: text.startIndex..<text.endIndex)
            .map { text[$0].trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.split(separator: " ").count >= 4 }      // skip tiny bits like "Go on."
            .prefix(40)
        guard !sentences.isEmpty else { return nil }

        // 2. Add up each genre's probability over all sentences.
        var totals: [String: Double] = [:]
        for sentence in sentences {
            for (genre, probability) in model.predictedLabelHypotheses(for: sentence, maximumCount: genres.count) {
                totals[genre, default: 0] += probability
            }
        }

        // 3. The genre with the biggest total wins. Confidence = its share of all the evidence.
        guard let best = totals.max(by: { $0.value < $1.value }) else { return nil }
        return (best.key, best.value / Double(sentences.count))
    }
}
