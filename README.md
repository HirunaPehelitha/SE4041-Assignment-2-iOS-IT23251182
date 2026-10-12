# BookNest – a simple e-book reader for iPhone and iPad

SE4041 MADD – Assignment 2, Part A (IT23251182)

BookNest is a Kindle-style reading app. You can read books page by page, change the page
colour and text size, bookmark pages, and turn a **paper book into an e-book** by taking photos
of its pages. Apple's **Vision** framework reads the text, **our own Core ML model** (trained with
Create ML) predicts each book's genre, and a **Reading Assistant** built on
Apple Intelligence (Foundation Models) summarises pages, explains hard words and makes quizzes.
Everything runs on the device.

**Who it's for:** students and readers in Sri Lanka who own printed books and notes and want
to read them comfortably on their phone. See [docs/01_PURPOSE_AND_AUDIENCE.md](docs/01_PURPOSE_AND_AUDIENCE.md).

## How the app is organised

```
IT23251182-IOS-Application/
├── BookNestApp.swift      app start: creates the database, shows the 3 tabs
├── Models/
│   ├── Book.swift         SwiftData model: title, text, current page, bookmarks
│   ├── Bookmark.swift     SwiftData model: a saved page
│   └── SampleBooks.swift  3 short stories added on first launch
├── Views/
│   ├── LibraryView.swift  screen 1 – greeting, Continue Reading card, filter/search/sort, book grid
│   ├── ReaderView.swift   screen 2 – reading, page swipe, bookmarks, settings, ✨ assistant
│   ├── BookmarksView.swift screen 3 – all bookmarks
│   ├── AddBookView.swift  screen 4 – type/paste text or scan photos
│   ├── ProfileView.swift  screen 5 – name, reading stats, default settings
│   ├── AssistantView.swift sheet – AI summary / explain words / quiz
│   ├── GenreTag.swift     small genre label
│   ├── BookCoverView.swift custom component – draws a cover
│   └── ReadingProgressBar.swift custom component – animated progress bar
└── Helpers/
    ├── Paginator.swift    splits text into pages
    ├── GenreClassifier.swift Core ML genre prediction (main emerging tech)
    ├── TextScanner.swift  Vision text recognition
    ├── BookAssistant.swift Apple Intelligence / Foundation Models
    └── ReaderStyle.swift  page colours, text sizes, custom `.readerPage()` ViewModifier

IT23251182-IOS-Application/ML/BookGenreClassifier.mlmodel   the trained Core ML model
ML/genre_training_data.csv     120 labelled example passages
ML/train_genre_model.swift     Create ML training script (swift ML/train_genre_model.swift)
```

## Assignment checklist (Part A)

| # | Requirement | Where |
|---|---|---|
| 1 | Purpose & audience | [docs/01_PURPOSE_AND_AUDIENCE.md](docs/01_PURPOSE_AND_AUDIENCE.md) |
| 2 | Animations, gestures, adaptive layout | swipe to turn pages, long-press to bookmark or delete, swipe to delete bookmarks, bookmark bounce, animated progress bars; adaptive grid; tested on iPhone, iPad and in landscape |
| 3 | Theme + custom component / ViewModifier | `BookCoverView`, `ReadingProgressBar`, `.readerPage()` modifier, accent colour |
| 4 | NavigationStack, 3+ screens | Library → Reader, Bookmarks → Reader, Add Book, Profile (3 tabs) |
| 5 | SwiftData | `Book`, `Bookmark` (reading position saved automatically) |
| 6 | Emerging tech | **Core ML**: own genre model trained with Create ML, 87% test accuracy ([docs/04_COREML_GENRE_MODEL.md](docs/04_COREML_GENRE_MODEL.md)); plus **Vision** text recognition and an **Apple Intelligence** reading assistant |
| 7 | Icon, branding, Dark Mode, Dynamic Type, accessibility | custom app icon (light, dark and tinted), warm orange brand colour, night page, text styles, VoiceOver labels |
| 8 | Testing & performance | unit, UI, landscape and performance tests (all passing on iPhone and iPad) – [docs/03_PERFORMANCE.md](docs/03_PERFORMANCE.md); UAT plan in [docs/02_USER_ACCEPTANCE_TESTING.md](docs/02_USER_ACCEPTANCE_TESTING.md) |

## Running

Open `IT23251182-IOS-Application.xcodeproj` in Xcode 26.1+, choose an iPhone or iPad simulator, press **⌘R**.
Run the tests with **⌘U**.

- **Scanner:** drag a photo of a book page onto the simulator window to add it to Photos, then use
  **Add Book → Scan Pages from Photos**.
- **Reading Assistant (✨):** needs a device or Mac with Apple Intelligence turned on. On other devices
  the app shows a friendly "Assistant Unavailable" message instead.

## AI usage

See [docs/AI_USAGE_LOG.md](docs/AI_USAGE_LOG.md).
