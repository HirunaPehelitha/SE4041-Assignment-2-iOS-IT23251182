//
//  BookAssistant.swift
//  BookNest
//
//  EMERGING TECH (2): uses Apple's on-device AI model (Foundation Models / Apple Intelligence)
//  to summarise a page or explain difficult words. Everything runs on the iPhone –
//  no internet and no data leaves the device.
//

import Foundation
import FoundationModels

enum BookAssistant {

    /// What the reader wants the AI to do with the page.
    enum Task: String, CaseIterable, Identifiable {
        case summary = "Summary"
        case words = "Explain Words"
        case quiz = "Quiz Me"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .summary: "text.alignleft"
            case .words: "character.book.closed"
            case .quiz: "questionmark.bubble"
            }
        }
    }

    /// Tells the model how to behave for every request.
    static let instructions = """
        You are a friendly reading assistant inside an e-book app.
        Use simple English that a school student can understand.
        Only use information from the page you are given. Keep answers short.
        """

    /// Builds the question we send to the model. Kept separate so it can be unit-tested.
    static func prompt(for task: Task, page: String) -> String {
        switch task {
        case .summary:
            "Summarise this page in 2 or 3 short sentences:\n\n\(page)"
        case .words:
            "Pick up to 5 difficult words from this page. For each one, write the word, a dash, and a short simple meaning. One word per line:\n\n\(page)"
        case .quiz:
            "Write 3 short questions to check that a reader understood this page, then the answers. Number them:\n\n\(page)"
        }
    }

    /// nil when the AI can be used, otherwise a friendly message explaining why not.
    static var unavailableMessage: String? {
        switch SystemLanguageModel.default.availability {
        case .available:
            return nil
        case .unavailable(.deviceNotEligible):
            return "This device doesn't support Apple Intelligence."
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Turn on Apple Intelligence in Settings to use the reading assistant."
        case .unavailable(.modelNotReady):
            return "The AI model is still downloading. Please try again in a few minutes."
        case .unavailable:
            return "The reading assistant isn't available right now."
        }
    }

    /// Sends the page to the on-device model and returns its answer.
    static func ask(_ task: Task, page: String) async throws -> String {
        let session = LanguageModelSession(instructions: instructions)
        let response = try await session.respond(to: prompt(for: task, page: page))
        return response.content
    }
}
