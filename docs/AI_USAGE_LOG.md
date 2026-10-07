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
