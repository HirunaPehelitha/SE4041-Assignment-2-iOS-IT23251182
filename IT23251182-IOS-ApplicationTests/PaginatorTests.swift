//
//  PaginatorTests.swift
//  BookNestTests
//

import Testing
@testable import IT23251182_IOS_Application

@MainActor
struct PaginatorTests {

    @Test func emptyTextGivesOneEmptyPage() {
        #expect(Paginator.pages(from: "") == [""])
    }

    @Test func shortTextFitsOnOnePage() {
        let pages = Paginator.pages(from: "Once upon a time")
        #expect(pages == ["Once upon a time"])
    }

    @Test func longTextIsSplitIntoPages() {
        // 250 words with 100 words per page -> 100 + 100 + 50
        let text = Array(repeating: "word", count: 250).joined(separator: " ")
        let pages = Paginator.pages(from: text, wordsPerPage: 100)

        #expect(pages.count == 3)
        #expect(pages[2].split(separator: " ").count == 50)
    }

    @Test func noWordsAreLost() {
        let text = SampleBooks.kiteStory
        let joined = Paginator.pages(from: text).joined(separator: " ")
        #expect(joined == text.split(separator: " ").joined(separator: " "))
    }

    @Test func snippetShowsFirstWords() {
        let snippet = Paginator.snippet(of: "one two three four five", wordCount: 3)
        #expect(snippet == "one two three…")
    }
}
