//
//  Bookmark.swift
//  BookNest
//
//  A saved page inside a book (SwiftData model).
//

import Foundation
import SwiftData

@Model
final class Bookmark {
    var pageIndex: Int
    var snippet: String           // the first few words of the page, shown in the list
    var dateCreated: Date
    var book: Book?

    init(pageIndex: Int, snippet: String) {
        self.pageIndex = pageIndex
        self.snippet = snippet
        self.dateCreated = .now
    }
}
