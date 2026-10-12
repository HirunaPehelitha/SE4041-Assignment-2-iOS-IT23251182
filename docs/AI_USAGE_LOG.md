# AI Usage Log

Module rule: every use of AI tools must be recorded with the prompt, a summary of the response,
and how it was used. Keep adding an entry each time you use an AI tool.

| Field | Meaning |
|---|---|
| Tool | e.g. Claude Code (Claude Opus 5.5) |
| Prompt | what you asked (copy it exactly) |
| Response summary | what the AI produced |
| How I used it | kept / changed / rejected, and why |
| What I learned | something you can explain in the viva |

---

## Entry 1 – 2026-10-07 – Understanding the brief and choosing an idea

- **Tool:** Claude Code (Claude Opus 5.5)
- **Prompts:**
  1. Shared the assignment PDF and asked for a summary.
  2. "what are the most trending application in the world under ios category"
  3. "under each category"
  4. "like Duolingo one for IOS application"
- **Response summary:** Summarised Parts A and B and the marking rubric. Listed today's top free
  iPhone apps in each App Store category (from Apple's top-charts feed). Proposed three Duolingo-style ideas:
  a Sinhala/Tamil letter tracer using CoreML ("Akuru"), a sign-language learner using Vision
  hand-pose detection, and a spoken-English coach using the Speech framework.
- **How I used it:** _(fill in: why you chose Akuru, and what you changed in the idea)_
- **What I learned:** _(fill in)_

## Entry 2 – 2026-10-07 – Git and GitHub setup

- **Prompts:** "https://github.com/HirunaPehelitha/IOS-IT23251182.git add to this repo", "do it for me",
  "can we upload this file later to github"
- **Response summary:** Linked the local project to the GitHub remote, merged the README that was
  already on GitHub, added an Xcode `.gitignore` and stopped tracking `xcuserdata`. Pushing was postponed.
- **How I used it:** _(fill in)_
- **What I learned:** _(fill in, e.g. what `--allow-unrelated-histories` does)_

## Entry 3 – 2026-10-07 – First idea "Akuru" (kept on branch `feature/project-setup`, not used)

- **Prompt:** "yes continue"
- **Response summary:** Generated the starting MVVM structure:
  - Added unit-test and UI-test targets and a shared scheme.
  - SwiftData models: `Lesson`, `Letter`, `PracticeAttempt`, `UserProgress`; seed lessons.
  - Services: `StreakCalculator`, `XPCalculator`, `ProgressRecorder`.
  - Theme with light/dark brand colours and Dynamic Type fonts.
  - Custom components: `ProgressRing`, `CardStyle` ViewModifier, `PressableButtonStyle`.
  - Screens: Learn, Lesson detail, Practice (swipe gesture, placeholder tracing area), Progress, Profile.
  - 14 unit tests (Swift Testing) and 4 UI tests (XCUITest), all passing.
  - A unit test found a bug: SwiftData's batch delete failed because of the Letter relationship.
    It was fixed by deleting the attempts one at a time.
- **How I used it:** _(fill in: what you reviewed, rewrote or changed)_
- **What I learned:** _(fill in)_
- **Still my own work:** the tracing canvas, the CoreML model (trained in Create ML), Vision
  integration, app icon, UAT and Instruments profiling.

## Entry 4 – 2026-10-07 – Switched idea to BookNest (branch `feature/booknest`)

- **Prompt:** "that application was too complicated i coulndt understand for that build another application Kindle"
- **Response summary:** Built a simpler Kindle-style reader called BookNest. It has 2 SwiftData models
  (`Book`, `Bookmark`), 4 screens (Library, Reader, Bookmarks, Add Book), a custom `BookCoverView`
  component, a custom `.readerPage()` ViewModifier, Vision text recognition for scanning paper pages,
  3 short original sample stories, 11 unit tests and 4 UI tests (all passing).
- **How I used it:** _(fill in: which parts you read, changed or rewrote yourself)_
- **What I learned:** _(fill in, e.g. how `TabView(.page)` gives swipe-to-turn-page, how `@Query` works)_

## Entry 5 – 2026-10-07 – Profile screen

- **Prompts:** "can u run this", "do it have three screen", "make like somthing profile"
- **Response summary:** Ran the app in the simulator and confirmed it has 4 screens. Added a Profile tab
  (`ProfileView.swift`) with the reader's name and an initials picture saved with `@AppStorage`, reading
  stats worked out from SwiftData (books started and finished, pages read, bookmarks), and default reading
  settings. Added a UI test for it. All 16 tests pass.
- **How I used it:** _(fill in)_
- **What I learned:** _(fill in, e.g. the difference between @AppStorage and SwiftData)_

## Entry 6 – 2026-10-07 – Professional Library screen

- **Prompt:** "add more more things to like completion bar to read bar in the main screen more like professional one"
- **Response summary:** Redesigned `LibraryView` with a time-of-day greeting, a "Continue Reading" card
  (cover, progress bar, % complete, page number, Resume button), All/Reading/Finished/New filter, search,
  sort menu, and a progress bar or NEW badge under every book. Added a `ReadingProgressBar` custom
  component that animates when it appears, plus `isReading` and `isFinished` on `Book`. Added 1 unit test and 1 UI test.
  All 18 tests pass.
- **How I used it:** _(fill in)_
- **What I learned:** _(fill in, e.g. how computed properties filter and sort the books)_

## Entry 7 – 2026-10-07 – Checking against the brief and finishing the "partly done" items

- **Prompts:** "do we need ad anything Ai related thing", "all needed in this doc has completed or not",
  "Part A - partly ones need to be Done"
- **Response summary:**
  - Compared the app with every requirement in the assignment PDF and listed what was done, partly done and missing.
  - Added a **Reading Assistant** (`BookAssistant.swift`, `AssistantView.swift`) using Apple's on-device
    Foundation Models: page summary, explain difficult words, 3-question quiz, and a friendly message when
    Apple Intelligence is unavailable. Tested live in the simulator.
  - Drew a custom **app icon** (open book in a nest with an AI sparkle) in light, dark and tinted versions.
  - Added a **landscape UI test** and ran every test on **iPhone 17 and iPad Air**. The tests found that the
    iPad's floating tab bar and the landscape swipe needed different handling in the tests.
  - Added **XCTest performance tests** (paginating and creating a ~100,000-word book) and launch-time measurement.
  - Wrote drafts of **Purpose & Audience** and the **UAT plan / questionnaire / results table**.
- **How I used it:** _(fill in – the purpose text must be rewritten in your own words, and the UAT must be done with real people)_
- **What I learned:** _(fill in, e.g. how LanguageModelSession works, why the AI runs on-device)_

## Entry 8 – 2026-10-12 – Core ML genre classifier (branch `feature/coreml-genre`)

- **Prompt:** "Emerging technologyfor this you can use like core ML or like a thing"
- **Response summary:**
  - Wrote 120 original example passages in 5 genres (`ML/genre_training_data.csv`) and a Create ML training
    script (`ML/train_genre_model.swift`). Trained a text classifier: 98.9% training and 87.0% testing accuracy.
  - Added `GenreClassifier.swift` (Core ML + NaturalLanguage), a `genre` field on `Book`, genre tags and chips
    in the Library, live "Detected Genre" in Add Book, and "Favourite genre" in Profile.
  - Unit tests found 2 problems: long texts were labelled "Adventure", and the generated model class crashed.
    Fixed with sentence-level scoring and by loading the model with `MLModel(contentsOf:)`. Also compared the
    maxEnt algorithm (65% test accuracy) with transfer learning (75% → 87% after adding data).
  - Documented everything in `docs/04_COREML_GENRE_MODEL.md`.
- **How I used it:** _(fill in – e.g. open the CSV in the Create ML app, retrain it, and add your own examples)_
- **What I learned:** _(fill in – e.g. training vs testing accuracy, overfitting, why sentence-level voting helped)_
