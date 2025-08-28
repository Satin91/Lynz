//
//  MainButtonView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI

struct MainButtonView: View {
    
    // MARK: - Button Styles
    enum ButtonStyle {
        case filled(Color)
        case outlined(Color)
        
        var backgroundColor: Color {
            switch self {
            case .filled(let color):
                return color
            case .outlined:
                return .clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .filled(let color):
                return color == .lzBlack ? .lzWhite : .lzBlack
            case .outlined(let color):
                return color
            }
        }
        
        var borderColor: Color {
            switch self {
            case .filled:
                return .clear
            case .outlined(let color):
                return color
            }
        }
    }
    
    // MARK: - Properties
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    // MARK: - Initializer
    init(
        title: String,
        style: ButtonStyle = .filled(.lzAccent),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.lynzMedium17)
                .foregroundStyle(style.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style.borderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Convenience Initializers
extension MainButtonView {
    /// Кнопка с заливкой
    static func filled(
        title: String,
        color: Color = .lzAccent,
        action: @escaping () -> Void
    ) -> MainButtonView {
        MainButtonView(title: title, style: .filled(color), action: action)
    }
    
    /// Кнопка с обводкой
    static func outlined(
        title: String,
        color: Color = .lzAccent,
        action: @escaping () -> Void
    ) -> MainButtonView {
        MainButtonView(title: title, style: .outlined(color), action: action)
    }
}

// MARK: - Predefined Styles
extension MainButtonView {
    /// Предустановленные стили для быстрого использования
    static let primary = ButtonStyle.filled(.lzAccent)
    static let secondary = ButtonStyle.outlined(.lzAccent)
    static let white = ButtonStyle.filled(.lzWhite)
    static let black = ButtonStyle.filled(.lzBlack)
    static let whiteOutlined = ButtonStyle.outlined(.lzWhite)
    static let blackOutlined = ButtonStyle.outlined(.lzBlack)
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        MainButtonView.filled(title: "Primary Button") { }
        MainButtonView.outlined(title: "Secondary Button") { }
        MainButtonView(title: "Custom Style", style: .filled(.lzBlack)) { }
        MainButtonView(title: "White Outlined", style: .outlined(.lzWhite)) { }
    }
    .padding()
    .background(Color.lzBlack.opacity(0.1))
}
