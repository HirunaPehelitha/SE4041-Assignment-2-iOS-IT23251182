//
//  train_genre_model.swift
//  BookNest – Core ML model training
//
//  Trains the "BookGenreClassifier" text classifier with Apple's Create ML framework
//  and saves it as a Core ML model that the app uses.
//
//  Run from the project folder (on a Mac):
//      swift ML/train_genre_model.swift
//
//  You can also open genre_training_data.csv in the Create ML app
//  (Xcode → Open Developer Tool → Create ML → Text Classifier) and get the same kind of model.
//

import CreateML
import Foundation

let folder = URL(fileURLWithPath: "ML")
let dataURL = folder.appendingPathComponent("genre_training_data.csv")
let outputURL = URL(fileURLWithPath: "IT23251182-IOS-Application/ML/BookGenreClassifier.mlmodel")

// 1. Load the labelled examples (columns: text, label).
let table = try MLDataTable(contentsOf: dataURL)

// 2. Keep 20% of the examples aside to test the model on text it has never seen.
let (trainingData, testingData) = table.randomSplit(by: 0.8, seed: 42)

// 3. Train. Transfer learning uses Apple's built-in word embeddings,
//    so the model understands words that are not in our small dataset.
//    (We also tried .maxEnt: 65% test accuracy vs 75% for transfer learning.)
let parameters = MLTextClassifier.ModelParameters(
    validation: .split(strategy: .automatic),
    algorithm: .transferLearning(.staticEmbedding, revision: 1),
    language: .english
)
let classifier = try MLTextClassifier(trainingData: trainingData,
                                      textColumn: "text",
                                      labelColumn: "label",
                                      parameters: parameters)

// 4. Measure accuracy.
let trainingAccuracy = (1 - classifier.trainingMetrics.classificationError) * 100
let evaluation = classifier.evaluation(on: testingData, textColumn: "text", labelColumn: "label")
let testingAccuracy = (1 - evaluation.classificationError) * 100
print(String(format: "Training accuracy: %.1f%%", trainingAccuracy))
print(String(format: "Testing accuracy:  %.1f%%", testingAccuracy))

// 5. Save the Core ML model into the app.
let metadata = MLModelMetadata(author: "IT23251182",
                               shortDescription: "Predicts a book's genre (Adventure, Nature, Family, Science, Mystery) from its text.",
                               version: "1.0")
try FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
try classifier.write(to: outputURL, metadata: metadata)
print("Saved model to \(outputURL.path)")
