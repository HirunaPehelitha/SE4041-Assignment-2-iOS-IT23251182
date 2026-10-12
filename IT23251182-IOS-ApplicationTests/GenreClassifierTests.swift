//
//  GenreClassifierTests.swift
//  BookNestTests
//
//  Checks that our Core ML genre model loads and gives sensible answers.
//

import Testing
@testable import IT23251182_IOS_Application

@MainActor
struct GenreClassifierTests {

    @Test func emptyTextHasNoGenre() {
        #expect(GenreClassifier.predict("") == nil)
        #expect(GenreClassifier.predict("   ") == nil)
    }

    @Test func predictionIsOneOfTheKnownGenres() throws {
        let result = try #require(GenreClassifier.predict("Once upon a time there was a story."))
        #expect(GenreClassifier.genres.contains(result.genre))
        #expect(result.confidence > 0 && result.confidence <= 1)
    }

    // Short passages the model has never seen (they are not in the training CSV).
    @Test(arguments: [
        ("The detective studied the broken lock and the missing key, and knew the butler was lying.", "Mystery"),
        ("Photosynthesis and respiration are two processes that keep plants and animals alive.", "Science"),
        ("Wild elephants and deer gathered at the lake as the rain began to fall on the forest.", "Nature"),
        ("My grandmother and grandfather cooked dinner for the whole family every Sunday.", "Family"),
    ])
    func predictsGenreOfNewText(text: String, expected: String) {
        #expect(GenreClassifier.predict(text)?.genre == expected)
    }

    @Test func sampleBooksGetSensibleGenres() {
        #expect(GenreClassifier.predict(SampleBooks.elephantStory)?.genre == "Nature")
        #expect(GenreClassifier.predict(SampleBooks.kitchenStory)?.genre == "Family")
    }

    @Test func newBookIsGivenAGenre() {
        let book = Book(title: "Test", author: "Me", text: SampleBooks.elephantStory)
        #expect(book.genre == "Nature")
    }
}
