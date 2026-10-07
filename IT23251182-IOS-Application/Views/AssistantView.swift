//
//  AssistantView.swift
//  BookNest
//
//  The ✨ sheet in the reader: summary, word meanings or a quick quiz for the current page,
//  made by the on-device AI model (see BookAssistant.swift).
//

import SwiftUI

struct AssistantView: View {
    let pageText: String

    @State private var task: BookAssistant.Task = .summary
    @State private var answer = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Task", selection: $task) {
                    ForEach(BookAssistant.Task.allCases) { Label($0.rawValue, systemImage: $0.icon).tag($0) }
                }
                .pickerStyle(.segmented)

                ScrollView {
                    Group {
                        if let message = BookAssistant.unavailableMessage {
                            ContentUnavailableView("Assistant Unavailable", systemImage: "sparkles",
                                                   description: Text(message))
                        } else if isLoading {
                            HStack(spacing: 12) {
                                ProgressView()
                                Text("Thinking…").foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 120)
                        } else if let errorMessage {
                            Label(errorMessage, systemImage: "exclamationmark.triangle")
                                .foregroundStyle(.red)
                        } else {
                            Text(answer)
                                .font(.system(.body, design: .serif))
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity)
                                .accessibilityIdentifier("assistant.answer")
                        }
                    }
                    .animation(.easeInOut, value: isLoading)
                }

                Label("Made on your iPhone with Apple Intelligence. AI can make mistakes.",
                      systemImage: "lock.shield")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Reading Assistant")
            .navigationBarTitleDisplayMode(.inline)
            // Runs when the sheet opens and again whenever the task changes.
            .task(id: task) { await generate() }
        }
    }

    private func generate() async {
        guard BookAssistant.unavailableMessage == nil else { return }
        isLoading = true
        errorMessage = nil
        do {
            answer = try await BookAssistant.ask(task, page: pageText)
        } catch is CancellationError {
            return            // the user switched task before the answer arrived
        } catch {
            errorMessage = "Sorry, the assistant couldn't answer. Please try again."
        }
        isLoading = false
    }
}

#Preview {
    AssistantView(pageText: SampleBooks.kiteStory)
}
