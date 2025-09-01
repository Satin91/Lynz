//
//  HeaderButton.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

/// Кнопка для использования в заголовке экрана
struct HeaderButton: View {
    
    enum ButtonImage: String {
        case pencil
        case checkmark
        case plus
    }
    
    
    // MARK: - Properties
    let color: Color
    let image: ButtonImage
    var isActive = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    // MARK: - Configuration
    private let buttonSize: CGFloat = 50
    
    var body: some View {
        Button(action: action) {
            if isActive {
                Circle()
                    .fill(color)
            } else {
                Circle()
                    .stroke(.lzWhite, lineWidth: 1)
            }
        }
        .frame(width: buttonSize, height: buttonSize)
        .overlay {
            Image(systemName: image.rawValue)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(isActive ? .lzBlack : .lzWhite)
        }
        .contentShape(Circle())
        .opacity(isDisabled ? 0.2 : 1)
        .disabled(isDisabled)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            HeaderButton(color: .lzWhite, image: .pencil) {
                print("White button tapped")
            }
            
            HeaderButton(color: .lzAccent, image: .plus) {
                print("Accent button tapped")
            }
            
            HeaderButton(color: .lzBlue, image: .checkmark) {
                print("Blue button tapped")
            }
        }
        
        Text("Header Buttons Preview")
            .font(.lzBody)
            .foregroundStyle(.lzWhite)
    }
    .padding()
    .background(Color.lzGray)
}
