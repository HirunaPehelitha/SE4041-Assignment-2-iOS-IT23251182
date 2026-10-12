# 3. Performance & Optimisation

The assignment asks for optimisation of **memory, load times and responsiveness**, checked with tools.
BookNest uses two kinds of evidence: automated performance tests and Instruments profiling.

## 3.1 Automated performance tests (XCTest)

| Test | What it measures | File |
|---|---|---|
| `testLaunchPerformance` | App launch time (`XCTApplicationLaunchMetric`) | `BookNestUITests.swift` |
| `testPaginatingALongBook` | Time and memory to split a ~100,000-word book (~400 pages) into pages | `PerformanceTests.swift` |
| `testCreatingALongBook` | Time to create and paginate a long scanned book | `PerformanceTests.swift` |

**How to get the numbers:** in Xcode open the **Test navigator (⌘6)**, run the 3 tests above, then click the
grey ◆ next to each `measure` line to see the average. Copy them below.

| Test | Device | Average result |
|---|---|---|
| Launch time | iPhone 17 simulator | _fill in_ s |
| Paginate 100k words | iPhone 17 simulator | _fill in_ s, _fill in_ kB |
| Create long book | iPhone 17 simulator | _fill in_ s |

## 3.2 Instruments profiling (do this yourself – take screenshots for the report)

1. In Xcode choose **Product → Profile (⌘I)**. This builds a Release version and opens Instruments.
2. **Time Profiler:** record for about 30 s while you open a book, turn 10 pages, open the ✨ assistant and
   scroll the library. Screenshot the heaviest stack trace. Expect most time to be in SwiftUI layout;
   `Paginator.pages(from:)` should be small.
3. **Leaks:** record while you open and close the reader 5 times and add and delete a book. A green ✓
   means no leaks. Screenshot it.
4. **Allocations:** check that memory goes back down after closing a long book.
5. **SwiftUI** instrument (optional): check that turning a page doesn't redraw the whole library.

| Instrument | Scenario | Result | Screenshot |
|---|---|---|---|
| Time Profiler | open book, turn pages, assistant | _fill in_ | _add_ |
| Leaks | open/close reader ×5, add/delete book | _fill in_ | _add_ |
| Allocations | memory after closing a long book | _fill in_ MB | _add_ |

## 3.3 Optimisation decisions already in the code

| Area | Decision | Why it helps |
|---|---|---|
| Load time | Sample books are inserted only when the library is empty (`SampleBooks.addIfLibraryIsEmpty`) | No work on later launches |
| Load time | `pageCount` is stored when a book is created | The Library shows progress without paginating every book |
| Memory | `LazyVGrid` in the Library | Covers are only built when they scroll on screen |
| Memory | Covers are drawn with gradients and text, not images | No image files to load or keep in memory |
| Responsiveness | Vision scanning and Apple Intelligence calls are `async` | The UI never freezes while they work; a spinner is shown |
| Responsiveness | `.task(id:)` in the assistant cancels the old request when the user switches tab | No wasted AI work and no wrong answers shown |
| Memory | Bookmarks use `deleteRule: .cascade` | Deleting a book removes its bookmarks, so no orphaned data |
| Battery and privacy | All AI and OCR run on the device | No network requests |

## 3.4 Testing summary

- Unit tests (Swift Testing): Paginator, Book progress and status, bookmarks, cascade delete, sample data, AI prompts.
- UI tests (XCUITest): open book and turn page, Continue Reading card, bookmark flow, add book, profile, landscape reader.
- All tests pass on **iPhone 17** and **iPad Air 11-inch (M3)** simulators (iOS 26.1).
