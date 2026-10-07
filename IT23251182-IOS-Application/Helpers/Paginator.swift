//
//  Paginator.swift
//  BookNest
//
//  Splits a long text into pages with a fixed number of words on each page.
//

import Foundation

enum Paginator {
    static let wordsPerPage = 120

    static func pages(from text: String, wordsPerPage: Int = wordsPerPage) -> [String] {
        // Split on spaces only, so line breaks stay attached to words and paragraphs survive.
        let words = text.split(separator: " ")

        // An empty book still gets one (empty) page, so the reader never crashes.
        if words.isEmpty {
            return [""]
        }

        var pages: [String] = []
        var start = 0
        while start < words.count {
            let end = min(start + wordsPerPage, words.count)
            pages.append(words[start..<end].joined(separator: " "))
            start = end
        }
        return pages
    }

    /// The first few words of a page, used as a bookmark preview.
    static func snippet(of page: String, wordCount: Int = 12) -> String {
        let words = page.split(whereSeparator: \.isWhitespace).prefix(wordCount)
        return words.joined(separator: " ") + (words.count == wordCount ? "…" : "")
    }
}
