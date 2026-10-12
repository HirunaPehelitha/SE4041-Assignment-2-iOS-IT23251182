# 4. Emerging Technology – Core ML Genre Classifier

BookNest uses **its own Core ML model** to predict each book's genre (Adventure, Nature, Family, Science or Mystery)
from the book's text. The prediction runs **on the device**, with no internet.

## 4.1 Where you see it in the app

| Screen | What Core ML does |
|---|---|
| Library | Genre tag under every book, and **genre chips** to filter the shelf (All Genres / Adventure / Nature / …). The search box also matches genres. |
| Continue Reading card | Shows the genre of the current book |
| Add Book | **Detected Genre** with a confidence %, updated live while typing or after scanning photos (Vision + Core ML together) |
| Profile | **Favourite genre**, worked out from the books you have opened |

## 4.2 How the model was made (Create ML)

| Step | Detail |
|---|---|
| Data | `ML/genre_training_data.csv`: 120 original, hand-written example passages (24 per genre), columns `text,label` |
| Tool | Apple **Create ML** (`MLTextClassifier`), run with `swift ML/train_genre_model.swift` |
| Split | 80% training, 20% kept aside for testing (seed 42, so results can be repeated) |
| Algorithm | **Transfer learning** with Apple's built-in English word embeddings (`.transferLearning(.staticEmbedding)`) |
| Output | `IT23251182-IOS-Application/ML/BookGenreClassifier.mlmodel` (Xcode compiles it into the app) |

The same CSV can also be opened in the **Create ML app** (Xcode → Open Developer Tool → Create ML → Text Classifier),
which shows the training graphs. These are useful screenshots for the report.

## 4.3 Results and what I changed

| Experiment | Training accuracy | Testing accuracy | Notes |
|---|---|---|---|
| 90 examples, transfer learning | 92.1% | 75.0% | Long stories were nearly all labelled "Adventure" |
| 90 examples, maximum entropy (`.maxEnt`) | 100% | 65.0% | Over-fitted: memorised the training data |
| **120 examples, transfer learning (final)** | **98.9%** | **87.0%** | Best result. Used in the app. |

Two problems found by the unit tests, and how they were fixed:

1. **Long books were mostly labelled "Adventure".** The model was trained on single sentences, but the app gave it
   a whole page. Fix in `GenreClassifier.predict`: split the text into sentences with `NLTokenizer`, ask the model
   about each sentence, **add up the probabilities**, and pick the genre with the most evidence.
2. **A crash in the long-book performance test.** The model class that Xcode generates crashed when it was released,
   because of a Swift concurrency problem with the project's default main-actor setting. Fix: load the compiled model
   directly with `MLModel(contentsOf:)` and wrap it in `NLModel`. The code is shorter and no longer crashes.

## 4.4 Code walkthrough (for the viva)

- `Helpers/GenreClassifier.swift`: loads the model once (`static let model`), splits text into sentences,
  calls `NLModel.predictedLabelHypotheses`, and returns `(genre, confidence)`.
- `Models/Book.swift`: `var genre: String = ""` is set when a book is created. The default value lets SwiftData
  update older saved books without a migration.
- `BookNestApp.swift`: fills in the genre for older books, and **re-labels every book when
  `GenreClassifier.modelVersion` changes**. This was added after a bug: books labelled by an early,
  weaker model kept their wrong "Adventure" genre after the model was improved.
- `Views/GenreTag.swift`, `LibraryView` (chips), `AddBookView` (live prediction), `ProfileView` (favourite genre).
- Tests: `GenreClassifierTests.swift` covers empty text, valid labels and confidence, 4 unseen passages, and the sample books.
  The UI tests check the genre filter chips and the live "Mystery" prediction in Add Book.

## 4.5 Limitations and future work

- Only 5 genres and 120 examples. More (and real) book text would improve accuracy.
- The examples are in English only. A Sinhala or Tamil model would need its own data.
- Future idea: let the user correct a wrong genre and use those corrections as new training data.
