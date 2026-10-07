//
//  BookmarksView.swift
//  BookNest
//
//  SCREEN 3: every bookmark from every book. Tap one to jump to that page,
//  swipe left to delete it.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Bookmark.dateCreated, order: .reverse) private var bookmarks: [Bookmark]
    @State private var path: [Book] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(bookmarks) { bookmark in
                    Button {
                        openBook(at: bookmark)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(bookmark.book?.title ?? "Unknown book")
                                .font(.headline)
                            Text("Page \(bookmark.pageIndex + 1)")
                                .font(.caption)
                                .foregroundStyle(.tint)
                            Text(bookmark.snippet)
                                .font(.system(.subheadline, design: .serif))
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .onDelete { offsets in
                    for index in offsets {
                        context.delete(bookmarks[index])
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .navigationDestination(for: Book.self) { book in
                ReaderView(book: book)
            }
            .overlay {
                if bookmarks.isEmpty {
                    ContentUnavailableView("No Bookmarks", systemImage: "bookmark",
                                           description: Text("Long-press a page while reading to bookmark it."))
                }
            }
        }
    }

    private func openBook(at bookmark: Bookmark) {
        guard let book = bookmark.book else { return }
        book.currentPage = bookmark.pageIndex
        path.append(book)
    }
}

#Preview {
    BookmarksView()
        .modelContainer(SampleBooks.previewContainer)
}
