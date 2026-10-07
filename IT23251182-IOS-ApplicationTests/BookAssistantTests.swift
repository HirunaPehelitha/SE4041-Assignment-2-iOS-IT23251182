//
//  BookAssistantTests.swift
//  BookNestTests
//
//  The AI answer itself changes every time, so we test the parts we control:
//  the prompts we send to the model.
//

import Testing
@testable import IT23251182_IOS_Application

@MainActor
struct BookAssistantTests {

    @Test(arguments: BookAssistant.Task.allCases)
    func everyPromptContainsThePage(task: BookAssistant.Task) {
        let page = "Nimal climbed the old ramparts of Galle Fort."
        #expect(BookAssistant.prompt(for: task, page: page).contains(page))
    }

    @Test func summaryPromptAsksForShortSummary() {
        let prompt = BookAssistant.prompt(for: .summary, page: "text")
        #expect(prompt.hasPrefix("Summarise this page"))
    }

    @Test func instructionsKeepTheModelOnThePage() {
        #expect(BookAssistant.instructions.contains("Only use information from the page"))
    }
}
