# BookNest – a simple e-book reader for iPhone and iPad

SE4041 MADD – Assignment 2, Part A (IT23251182)

BookNest is a Kindle-style reading app. You can read books page by page, change the page
colour and text size, bookmark pages, and turn a **paper book into an e-book** by taking photos
of its pages. Apple's **Vision** framework reads the text on the device.

**Who it's for:** students and readers in Sri Lanka who own printed books and notes and want
to read them comfortably on their phone, including at night in dark mode, without typing anything.

## How the app is organised

```
IT23251182-IOS-Application/
├── BookNestApp.swift      app start: creates the database, shows the 2 tabs
├── Models/
│   ├── Book.swift         SwiftData model: title, text, current page, bookmarks
│   ├── Bookmark.swift     SwiftData model: a saved page
│   └── SampleBooks.swift  3 short stories added on first launch
├── Views/
│   ├── LibraryView.swift  screen 1 – bookshelf grid
│   ├── ReaderView.swift   screen 2 – reading, page swipe, bookmarks, settings
│   ├── BookmarksView.swift screen 3 – all bookmarks
│   ├── AddBookView.swift  screen 4 – type/paste text or scan photos
│   └── BookCoverView.swift custom component – draws a cover
└── Helpers/
    ├── Paginator.swift    splits text into pages
    ├── TextScanner.swift  Vision text recognition (emerging tech)
    └── ReaderStyle.swift  page colours, text sizes, custom `.readerPage()` ViewModifier
```

## Assignment checklist

| # | Requirement | Where |
|---|---|---|
| 1 | Purpose & audience | above |
| 2 | Animations, gestures, adaptive layout | swipe to turn pages, long-press to bookmark or delete, swipe to delete bookmarks, bookmark bounce, adaptive grid on iPad |
| 3 | Theme + custom component / ViewModifier | `BookCoverView`, `.readerPage()` modifier, accent colour |
| 4 | NavigationStack, 3+ screens | Library → Reader, Bookmarks → Reader, Add Book |
| 5 | SwiftData | `Book`, `Bookmark` (reading position saved automatically) |
| 6 | Emerging tech | **Vision** text recognition in `TextScanner.swift` |
| 7 | Dark mode, Dynamic Type, accessibility | system colours + night page, text styles, VoiceOver labels |
| 8 | Testing | 11 unit tests, 3 UI tests and 1 launch-speed test, all passing. Still to do: user testing (UAT) and Instruments profiling |

## Running

Open `IT23251182-IOS-Application.xcodeproj` in Xcode 26.1+, choose an iPhone simulator, press **⌘R**.
Run the tests with **⌘U**.

To try the scanner in the simulator, drag a photo of a book page onto the simulator window
to add it to Photos, then use **Add Book → Scan Pages from Photos**.

## AI usage

See [docs/AI_USAGE_LOG.md](docs/AI_USAGE_LOG.md).
