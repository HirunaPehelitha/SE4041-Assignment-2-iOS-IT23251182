//
//  Book.swift
//  BookNest
//
//  A book saved in the library (SwiftData model).
//

import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var text: String
    var pageCount: Int
    var currentPage: Int          // the page the reader is on (starts at 0)
    var coverHue: Double          // 0...1, picks the colour of the cover
    var dateAdded: Date
    var lastOpened: Date?         // nil = never opened

    // When a book is deleted, its bookmarks are deleted too.
    @Relationship(deleteRule: .cascade, inverse: \Bookmark.book)
    var bookmarks: [Bookmark] = []

    init(title: String, author: String, text: String, coverHue: Double = Double.random(in: 0...1)) {
        self.title = title
        self.author = author
        self.text = text
        self.pageCount = Paginator.pages(from: text).count
        self.currentPage = 0
        self.coverHue = coverHue
        self.dateAdded = .now
    }

    /// How much of the book has been read, from 0 to 1.
    var progress: Double {
        guard lastOpened != nil, pageCount > 0 else { return 0 }
        return Double(currentPage + 1) / Double(pageCount)
    }

    /// The bookmark on a page, if there is one.
    func bookmark(onPage page: Int) -> Bookmark? {
        bookmarks.first { $0.pageIndex == page }
    }
}
