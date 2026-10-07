//
//  ReaderStyle.swift
//  BookNest
//
//  Reading settings: page colour and text size.
//  Also contains the custom `.readerPage(...)` ViewModifier.
//

import SwiftUI

/// The three page colours, like the Kindle app.
enum ReaderTheme: String, CaseIterable, Identifiable {
    case white, sepia, night

    var id: String { rawValue }

    var name: String { rawValue.capitalized }

    var background: Color {
        switch self {
        case .white: Color(white: 0.99)
        case .sepia: Color(red: 0.96, green: 0.92, blue: 0.83)
        case .night: Color(white: 0.08)
        }
    }

    var textColor: Color {
        switch self {
        case .white: .black
        case .sepia: Color(red: 0.28, green: 0.20, blue: 0.12)
        case .night: Color(white: 0.85)
        }
    }
}

/// Text sizes use text styles, so they still grow with the iPhone's Dynamic Type setting.
enum ReaderTextSize: String, CaseIterable, Identifiable {
    case small, medium, large, huge

    var id: String { rawValue }

    var textStyle: Font.TextStyle {
        switch self {
        case .small: .callout
        case .medium: .body
        case .large: .title3
        case .huge: .title2
        }
    }
}

/// CUSTOM VIEWMODIFIER: makes any text look like a page in a book.
struct ReaderPage: ViewModifier {
    let theme: ReaderTheme
    let size: ReaderTextSize

    func body(content: Content) -> some View {
        content
            .font(.system(size.textStyle, design: .serif))
            .lineSpacing(6)
            .foregroundStyle(theme.textColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .frame(maxWidth: 700, alignment: .leading)   // keeps lines readable on iPad
            .frame(maxWidth: .infinity)
    }
}

extension View {
    func readerPage(theme: ReaderTheme, size: ReaderTextSize) -> some View {
        modifier(ReaderPage(theme: theme, size: size))
    }
}
