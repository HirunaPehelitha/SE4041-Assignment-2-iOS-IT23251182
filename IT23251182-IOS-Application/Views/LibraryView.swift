//
//  LibraryView.swift
//  BookNest
//
//  SCREEN 1: the home screen.
//  - A greeting and a big "Continue Reading" card for the last book you opened
//  - Filter (All / Reading / Finished / New), search and sort
//  - A grid of books, each with a progress bar
//  Tap a book to read it, long-press to delete it.
//

import SwiftUI
import SwiftData

/// The filter buttons above the grid.
enum BookFilter: String, CaseIterable, Identifiable {
    case all = "All", reading = "Reading", finished = "Finished", new = "New"
    var id: String { rawValue }
}

/// The ways the grid can be sorted.
enum BookSort: String, CaseIterable, Identifiable {
    case recent = "Recently Read", title = "Title", added = "Date Added"
    var id: String { rawValue }
}

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Book.dateAdded) private var books: [Book]
    @AppStorage("readerName") private var name = ""

    @State private var filter: BookFilter = .all
    @State private var genreFilter: String?          // nil = all genres
    @State private var sort: BookSort = .recent
    @State private var searchText = ""
    @State private var showAddBook = false

    // "adaptive" fits as many columns as there is room for: 2 on iPhone, more on iPad / landscape.
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]

    /// The most recently opened book that is not finished yet.
    private var currentBook: Book? {
        books.filter(\.isReading).max { ($0.lastOpened ?? .distantPast) < ($1.lastOpened ?? .distantPast) }
    }

    /// The books shown in the grid after filter, search and sort.
    private var shownBooks: [Book] {
        var result = books

        switch filter {
        case .all: break
        case .reading: result = result.filter(\.isReading)
        case .finished: result = result.filter(\.isFinished)
        case .new: result = result.filter { $0.lastOpened == nil }
        }

        if let genreFilter {
            result = result.filter { $0.genre == genreFilter }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText) ||
                $0.genre.localizedCaseInsensitiveContains(searchText)
            }
        }

        switch sort {
        case .recent: result.sort { ($0.lastOpened ?? .distantPast) > ($1.lastOpened ?? .distantPast) }
        case .title: result.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .added: result.sort { $0.dateAdded > $1.dateAdded }
        }
        return result
    }

    /// "Good morning" / "Good afternoon" / "Good evening"
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        let partOfDay = hour < 12 ? "Good morning" : hour < 17 ? "Good afternoon" : "Good evening"
        return name.isEmpty ? partOfDay : "\(partOfDay), \(name.split(separator: " ").first ?? "")"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(greeting)
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    if let book = currentBook, searchText.isEmpty {
                        ContinueReadingCard(book: book)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Filter buttons
                    Picker("Filter", selection: $filter.animation(.snappy)) {
                        ForEach(BookFilter.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)

                    // Genre chips – the genres come from our Core ML model
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            GenreChip(title: "All Genres", icon: "square.grid.2x2", isSelected: genreFilter == nil) {
                                withAnimation(.snappy) { genreFilter = nil }
                            }
                            ForEach(GenreClassifier.genres.filter { genre in books.contains { $0.genre == genre } }, id: \.self) { genre in
                                GenreChip(title: genre, icon: GenreClassifier.icon(for: genre),
                                          isSelected: genreFilter == genre) {
                                    withAnimation(.snappy) { genreFilter = (genreFilter == genre) ? nil : genre }
                                }
                            }
                        }
                    }

                    // The grid of books
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 28) {
                        ForEach(shownBooks) { book in
                            NavigationLink(value: book) {
                                BookGridItem(book: book)
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
                    .animation(.snappy, value: shownBooks.map(\.id))

                    if shownBooks.isEmpty && !books.isEmpty {
                        ContentUnavailableView("No \(filter.rawValue) Books", systemImage: "magnifyingglass",
                                               description: Text("Try a different filter or search."))
                    }
                }
                .padding()
            }
            .navigationTitle("Library")
            .searchable(text: $searchText, prompt: "Search title or author")
            .navigationDestination(for: Book.self) { book in
                ReaderView(book: book)
            }
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort by", selection: $sort.animation(.snappy)) {
                        ForEach(BookSort.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
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

/// The big card at the top for the book you are reading now.
private struct ContinueReadingCard: View {
    let book: Book

    var body: some View {
        NavigationLink(value: book) {
            HStack(alignment: .top, spacing: 16) {
                BookCoverView(title: book.title, author: book.author, hue: book.coverHue)
                    .frame(width: 90)

                VStack(alignment: .leading, spacing: 8) {
                    Text("CONTINUE READING")
                        .font(.caption.bold())
                        .foregroundStyle(.tint)
                    Text(book.title)
                        .font(.system(.title3, design: .serif).bold())
                        .lineLimit(2)
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    GenreTag(genre: book.genre)

                    Spacer(minLength: 0)

                    ReadingProgressBar(progress: book.progress, height: 8)
                    HStack {
                        Text("\(Int(book.progress * 100))% complete")
                        Spacer()
                        Text("Page \(book.currentPage + 1) of \(book.pageCount)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Label("Resume", systemImage: "book.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor, in: .capsule)
                }
            }
            .padding()
            .background(.background.secondary, in: .rect(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("continueReading")
    }
}

/// One book in the grid: cover, title, author, progress bar and status.
private struct BookGridItem: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            BookCoverView(title: book.title, author: book.author, hue: book.coverHue)
                .overlay(alignment: .topTrailing) {
                    if book.isFinished {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .green)
                            .padding(6)
                    }
                }

            Text(book.title)
                .font(.subheadline.bold())
                .lineLimit(1)
            Text(book.author)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            GenreTag(genre: book.genre)

            if book.lastOpened == nil {
                Text("NEW")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.accentColor, in: .capsule)
            } else {
                ReadingProgressBar(progress: book.progress)
                Text(book.isFinished ? "Finished" : "\(Int(book.progress * 100))% read")
                    .font(.caption)
                    .foregroundStyle(book.isFinished ? .green : .secondary)
            }
        }
    }
}

/// A tappable genre filter button.
private struct GenreChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .foregroundStyle(isSelected ? .white : .primary)
                .background(isSelected ? AnyShapeStyle(Color.accentColor) : AnyShapeStyle(.quaternary), in: .capsule)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("genre.\(title)")
    }
}

#Preview {
    LibraryView()
        .modelContainer(SampleBooks.previewContainer)
}
