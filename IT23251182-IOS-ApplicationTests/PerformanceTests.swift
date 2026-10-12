//
//  PerformanceTests.swift
//  BookNestTests
//
//  XCTest performance tests: measure how long the slowest work in the app takes
//  for a very long book (e.g. a whole scanned textbook), so we can spot slow-downs.
//

import XCTest
@testable import IT23251182_IOS_Application

@MainActor
final class PerformanceTests: XCTestCase {
    /// About 100,000 words – roughly a 400-page book.
    private let longText = Array(repeating: SampleBooks.kiteStory, count: 300).joined(separator: "\n\n")

    func testPaginatingALongBook() {
        measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
            _ = Paginator.pages(from: longText)
        }
    }

    func testCreatingALongBook() {
        measure {
            _ = Book(title: "Long", author: "Test", text: longText)
        }
    }
}
