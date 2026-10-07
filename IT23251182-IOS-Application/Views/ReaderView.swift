//
//  ReaderView.swift
//  BookNest
//
//  SCREEN 2: reads a book. Swipe left/right to turn pages.
//  Long-press a page (or tap the bookmark button) to bookmark it.
//

import SwiftUI
import SwiftData

struct ReaderView: View {
    @Environment(\.modelContext) private var context
    @Bindable var book: Book
    let pages: [String]

    // @AppStorage remembers the user's choice even after the app closes.
    @AppStorage("readerTheme") private var theme: ReaderTheme = .sepia
    @AppStorage("readerTextSize") private var textSize: ReaderTextSize = .medium
    @State private var showSettings = false
    @State private var showAssistant = false

    init(book: Book) {
        self.book = book
        self.pages = Paginator.pages(from: book.text)
    }

    private var isBookmarked: Bool {
        book.bookmark(onPage: book.currentPage) != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            // A paging TabView gives us the swipe-to-turn-page gesture and animation for free.
            TabView(selection: $book.currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    ScrollView {
                        Text(pages[index])
                            .readerPage(theme: theme, size: textSize)
                    }
                    .tag(index)
                    .onLongPressGesture { toggleBookmark() }
                    .accessibilityIdentifier("reader.page")
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Footer: progress bar and page number.
            VStack(spacing: 6) {
                ProgressView(value: Double(book.currentPage + 1), total: Double(pages.count))
                    .tint(theme.textColor.opacity(0.6))
                Text("Page \(book.currentPage + 1) of \(pages.count)")
                    .font(.caption)
                    .foregroundStyle(theme.textColor.opacity(0.7))
                    .contentTransition(.numericText())
                    .accessibilityIdentifier("reader.pageNumber")
            }
            .padding()
        }
        .background(theme.background)
        .animation(.easeInOut, value: theme)
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)      // more room for reading, like Kindle
        .toolbar {
            Button(isBookmarked ? "Remove Bookmark" : "Add Bookmark",
                   systemImage: isBookmarked ? "bookmark.fill" : "bookmark") {
                toggleBookmark()
            }
            .symbolEffect(.bounce, value: isBookmarked)
            .accessibilityIdentifier("reader.bookmark")

            Button("Reading Assistant", systemImage: "sparkles") {
                showAssistant = true
            }
            .accessibilityIdentifier("reader.assistant")

            Button("Reading Settings", systemImage: "textformat.size") {
                showSettings = true
            }
        }
        .sheet(isPresented: $showSettings) {
            ReaderSettingsView(theme: $theme, textSize: $textSize)
                .presentationDetents([.height(260)])
        }
        .sheet(isPresented: $showAssistant) {
            AssistantView(pageText: pages[book.currentPage])
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            book.lastOpened = .now
        }
    }

    private func toggleBookmark() {
        withAnimation {
            if let existing = book.bookmark(onPage: book.currentPage) {
                context.delete(existing)
            } else {
                let bookmark = Bookmark(pageIndex: book.currentPage,
                                        snippet: Paginator.snippet(of: pages[book.currentPage]))
                bookmark.book = book
                context.insert(bookmark)
            }
        }
    }
}

/// The small sheet for changing page colour and text size.
struct ReaderSettingsView: View {
    @Binding var theme: ReaderTheme
    @Binding var textSize: ReaderTextSize

    var body: some View {
        NavigationStack {
            Form {
                Picker("Page colour", selection: $theme) {
                    ForEach(ReaderTheme.allCases) { Text($0.name).tag($0) }
                }
                .pickerStyle(.segmented)

                Picker("Text size", selection: $textSize) {
                    ForEach(ReaderTextSize.allCases) { Text($0.rawValue.capitalized).tag($0) }
                }
                .pickerStyle(.segmented)
            }
            .navigationTitle("Reading Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        ReaderView(book: SampleBooks.previewBook)
    }
    .modelContainer(SampleBooks.previewContainer)
}
