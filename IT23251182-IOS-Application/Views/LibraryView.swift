//
//  LibraryView.swift
//  BookNest
//
//  SCREEN 1: the bookshelf. Tap a book to read it, long-press to delete it.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.dateAdded) private var books: [Book]
    @State private var showAddBook = false

    // "adaptive" fits as many columns as there is room for: 2 on iPhone, more on iPad / landscape.
    private let columns = [GridItem(.adaptive(minimum: 130), spacing: 20)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(books) { book in
                        NavigationLink(value: book) {
                            VStack(alignment: .leading, spacing: 6) {
                                BookCoverView(title: book.title, author: book.author,
                                              hue: book.coverHue, progress: book.progress)
                                Text(book.title)
                                    .font(.subheadline.bold())
                                    .lineLimit(1)
                                Text(book.progress > 0 ? "\(Int(book.progress * 100))% read" : "New")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Delete Book", systemImage: "trash", role: .destructive) {
                                withAnimation { context.delete(book) }
                            }
                        }
                        .accessibilityIdentifier("book.\(book.title)")
                    }
                }
                .padding()
            }
            .navigationTitle("Library")
            .navigationDestination(for: Book.self) { book in
                ReaderView(book: book)
            }
            .toolbar {
                Button("Add Book", systemImage: "plus") {
                    showAddBook = true
                }
            }
            .sheet(isPresented: $showAddBook) {
                AddBookView()
            }
            .overlay {
                if books.isEmpty {
                    ContentUnavailableView("No Books", systemImage: "books.vertical",
                                           description: Text("Tap + to add your first book."))
                }
            }
        }
    }
}

#Preview {
    LibraryView()
        .modelContainer(SampleBooks.previewContainer)
}
