//
//  BookNestApp.swift
//  BookNest
//
//  The app starts here. It creates the SwiftData database and shows the tabs.
//

import SwiftUI
import SwiftData

@main
struct BookNestApp: App {
    let container: ModelContainer

    init() {
        // UI tests pass "-uiTesting" so they always start with a fresh, temporary database.
        let isUITesting = ProcessInfo.processInfo.arguments.contains("-uiTesting")
        if isUITesting {
            // Also forget saved settings (name, page colour…) from earlier test runs.
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }
        let config = ModelConfiguration(isStoredInMemoryOnly: isUITesting)
        container = try! ModelContainer(for: Book.self, Bookmark.self, configurations: config)

        // Put a few sample books on the shelf the first time the app opens.
        SampleBooks.addIfLibraryIsEmpty(container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Library", systemImage: "books.vertical.fill") {
                    LibraryView()
                }
                Tab("Bookmarks", systemImage: "bookmark.fill") {
                    BookmarksView()
                }
                Tab("Profile", systemImage: "person.crop.circle.fill") {
                    ProfileView()
                }
            }
        }
        .modelContainer(container)
    }
}
