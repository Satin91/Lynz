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
        case capsule(Color)
        case capsuleFill(Color)
        case roundedFill(Color)
        case roundedStroke(Color)
        
        var backgroundColor: Color {
            switch self {
            case .capsuleFill(let color):
                return color
            case .roundedFill(let color):
                return color
            case .capsule, .roundedStroke:
                return .clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .capsuleFill:
                return .lzWhite
            case .roundedFill(let color):
                return color == .lzBlack ? .lzWhite : .lzBlack
            case .capsule(let color), .roundedStroke(let color):
                return color
            }
        }
        
        var borderColor: Color {
            switch self {
            case .capsuleFill, .roundedFill:
                return .clear
            case .capsule(let color), .roundedStroke(let color):
                return color
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .capsule, .capsuleFill:
                return 28
            case .roundedFill, .roundedStroke:
                return 16
            }
        }
        
        var hasShadow: Bool {
            switch self {
            case .roundedFill:
                return true
            case .capsule, .capsuleFill, .roundedStroke:
                return false
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
        style: ButtonStyle,
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
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(style.borderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                .contentShape(Rectangle())
                .shadow(
                    color: style.hasShadow ? .black.opacity(0.1) : .clear,
                    radius: style.hasShadow ? 8 : 0,
                    x: 0,
                    y: style.hasShadow ? 4 : 0
                )
        }
//        .buttonStyle(PlainButtonStyle())
    }
}



// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Capsule стили
        MainButtonView(title: "Capsule Button", style: .capsule(.lzAccent)) { }
        MainButtonView(title: "Capsule Fill", style: .capsuleFill(.lzAccent)) { }
        
        // Rounded стили
        MainButtonView(title: "Black Fill", style: .roundedFill(.lzBlack)) { }
        MainButtonView(title: "White Fill", style: .roundedFill(.lzWhite)) { }
        MainButtonView(title: "Accent Stroke", style: .roundedStroke(.lzAccent)) { }
        MainButtonView(title: "White Stroke", style: .roundedStroke(.lzWhite)) { }
    }
    .padding()
    .background(Color.lzBlack.opacity(0.1))
}
