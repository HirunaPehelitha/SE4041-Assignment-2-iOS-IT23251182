//
//  BookTests.swift
//  BookNestTests
//
//  Tests the SwiftData models using a temporary in-memory database.
//

import Foundation
import SwiftData
import Testing
@testable import IT23251182_IOS_Application

@MainActor
struct BookTests {
    let container = try! ModelContainer(for: Book.self, Bookmark.self,
                                        configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    private func makeBook(words: Int) -> Book {
        let text = Array(repeating: "word", count: words).joined(separator: " ")
        let book = Book(title: "Test", author: "Me", text: text)
        container.mainContext.insert(book)
        return book
    }

    @Test func pageCountIsWorkedOutFromText() {
        let book = makeBook(words: Paginator.wordsPerPage * 3)
        #expect(book.pageCount == 3)
    }

    @Test func unopenedBookHasNoProgress() {
        let book = makeBook(words: 500)
        #expect(book.progress == 0)
    }

    @Test func progressFollowsCurrentPage() {
        let book = makeBook(words: Paginator.wordsPerPage * 4)
        book.lastOpened = .now
        book.currentPage = 1          // second of four pages
        #expect(book.progress == 0.5)
    }

    @Test func bookmarkCanBeFoundByPage() throws {
        let book = makeBook(words: 500)
        let bookmark = Bookmark(pageIndex: 2, snippet: "word word")
        bookmark.book = book
        container.mainContext.insert(bookmark)
        try container.mainContext.save()

        #expect(book.bookmark(onPage: 2) != nil)
        #expect(book.bookmark(onPage: 0) == nil)
    }

    @Test func deletingBookDeletesItsBookmarks() throws {
        let context = container.mainContext
        let book = makeBook(words: 500)
        let bookmark = Bookmark(pageIndex: 0, snippet: "word")
        bookmark.book = book
        context.insert(bookmark)
        try context.save()

        context.delete(book)
        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<Bookmark>()) == 0)
    }

    @Test func sampleBooksAreOnlyAddedOnce() throws {
        let context = container.mainContext
        SampleBooks.addIfLibraryIsEmpty(context)
        SampleBooks.addIfLibraryIsEmpty(context)
        #expect(try context.fetchCount(FetchDescriptor<Book>()) == SampleBooks.all.count)
    }
}
