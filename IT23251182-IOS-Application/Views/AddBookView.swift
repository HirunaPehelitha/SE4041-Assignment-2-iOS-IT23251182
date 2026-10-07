//
//  AddBookView.swift
//  BookNest
//
//  SCREEN 4: add a new book. Type or paste the text, or pick photos of book pages
//  and let the Vision framework read the text for you.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var text = ""
    @State private var pickedPhotos: [PhotosPickerItem] = []
    @State private var isScanning = false
    @State private var scanError: String?

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                        .accessibilityIdentifier("add.title")
                    TextField("Author", text: $author)
                        .accessibilityIdentifier("add.author")
                }

                Section {
                    PhotosPicker(selection: $pickedPhotos, matching: .images) {
                        Label("Scan Pages from Photos", systemImage: "doc.text.viewfinder")
                    }
                    if isScanning {
                        HStack {
                            ProgressView()
                            Text("Reading text…")
                        }
                    }
                    if let scanError {
                        Text(scanError).foregroundStyle(.red)
                    }
                } header: {
                    Text("Scan")
                } footer: {
                    Text("Take photos of the pages of a paper book. BookNest reads the text on your iPhone.")
                }

                Section("Text") {
                    TextEditor(text: $text)
                        .frame(minHeight: 200)
                        .font(.system(.body, design: .serif))
                        .accessibilityIdentifier("add.text")
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                        .accessibilityIdentifier("add.save")
                }
            }
            // Runs whenever the user picks new photos.
            .onChange(of: pickedPhotos) {
                Task { await scanPickedPhotos() }
            }
        }
    }

    private func scanPickedPhotos() async {
        isScanning = true
        scanError = nil
        for item in pickedPhotos {
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    let pageText = try await TextScanner.recognizeText(in: data)
                    text += (text.isEmpty ? "" : "\n\n") + pageText
                }
            } catch {
                scanError = "Couldn't read one of the photos."
            }
        }
        pickedPhotos = []
        isScanning = false
    }

    private func save() {
        let book = Book(title: title.trimmingCharacters(in: .whitespaces),
                        author: author.isEmpty ? "Unknown" : author,
                        text: text)
        context.insert(book)
        dismiss()
    }
}

#Preview {
    AddBookView()
        .modelContainer(SampleBooks.previewContainer)
}
