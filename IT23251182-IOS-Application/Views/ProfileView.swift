//
//  ProfileView.swift
//  BookNest
//
//  SCREEN 5: the reader's profile – name, reading stats and default reading settings.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    // The name is a simple setting, so @AppStorage is enough (no database needed).
    @AppStorage("readerName") private var name = ""
    @AppStorage("readerTheme") private var theme: ReaderTheme = .sepia
    @AppStorage("readerTextSize") private var textSize: ReaderTextSize = .medium

    // The stats are worked out from the books and bookmarks saved with SwiftData.
    @Query private var books: [Book]
    @Query private var bookmarks: [Bookmark]

    private var booksStarted: Int {
        books.filter { $0.lastOpened != nil }.count
    }

    private var booksFinished: Int {
        books.filter { $0.lastOpened != nil && $0.currentPage == $0.pageCount - 1 }.count
    }

    private var pagesRead: Int {
        books.filter { $0.lastOpened != nil }.reduce(0) { $0 + $1.currentPage + 1 }
    }

    /// "Hiruna Pehelitha" -> "HP"
    private var initials: String {
        let letters = name.split(separator: " ").prefix(2).compactMap(\.first)
        return letters.isEmpty ? "?" : String(letters).uppercased()
    }

    var body: some View {
        NavigationStack {
            Form {
                // Header: initials picture and name
                Section {
                    VStack(spacing: 12) {
                        Text(initials)
                            .font(.system(.largeTitle, design: .serif).bold())
                            .foregroundStyle(.white)
                            .frame(width: 96, height: 96)
                            .background(Color.accentColor.gradient, in: .circle)
                            .contentTransition(.numericText())
                            .animation(.snappy, value: initials)
                            .accessibilityHidden(true)

                        Text(name.isEmpty ? "Reader" : name)
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)

                    TextField("Your name", text: $name)
                        .textContentType(.name)
                        .accessibilityIdentifier("profile.name")
                }

                // Reading stats
                Section("Reading Stats") {
                    StatRow(title: "Books in library", value: books.count, icon: "books.vertical.fill")
                    StatRow(title: "Books started", value: booksStarted, icon: "book.fill")
                    StatRow(title: "Books finished", value: booksFinished, icon: "checkmark.seal.fill")
                    StatRow(title: "Pages read", value: pagesRead, icon: "doc.text.fill")
                    StatRow(title: "Bookmarks", value: bookmarks.count, icon: "bookmark.fill")
                }

                // Default reading settings (the same ones the AA button changes)
                Section("Reading Settings") {
                    Picker("Page colour", selection: $theme) {
                        ForEach(ReaderTheme.allCases) { Text($0.name).tag($0) }
                    }
                    Picker("Text size", selection: $textSize) {
                        ForEach(ReaderTextSize.allCases) { Text($0.rawValue.capitalized).tag($0) }
                    }
                }

                Section("About") {
                    LabeledContent("App", value: "BookNest")
                    LabeledContent("Version", value: "1.0")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

/// One line in the stats list: icon, title and number.
private struct StatRow: View {
    let title: String
    let value: Int
    let icon: String

    var body: some View {
        LabeledContent {
            Text("\(value)")
                .font(.headline)
                .contentTransition(.numericText())
        } label: {
            Label(title, systemImage: icon)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ProfileView()
        .modelContainer(SampleBooks.previewContainer)
}
