//
//  HeaderButton.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

/// Кнопка для использования в заголовке экрана
struct MainCircleButton: View {
    
    enum ButtonImage: String { // sf symbols names
        case pencil
        case checkmark
        case plus
        case chevronLeft = "chevron.left"
        case chevronRight = "chevron.right"
    }
    
    
    // MARK: - Properties
    let color: Color
    var activeColor: Color
    let image: ButtonImage
    var isActive = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    
    init(color: Color, activeColor: Color? = nil, image: ButtonImage, isActive: Bool = false, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.color = color
        
        self.image = image
        self.isActive = isActive
        self.isDisabled = isDisabled
        self.action = action
        if let activeColor {
                self.activeColor = activeColor
            } else {
                self.activeColor = color
            }
    }
    
    // MARK: - Configuration
    private let buttonSize: CGFloat = 50
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isActive {
                    Circle()
                        .fill(activeColor)
                } else {
                    Circle()
                        .stroke(lineWidth: 1)
                }
            }
            .overlay {
                Image(systemName: image.rawValue)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(isActive ? .lzBlack : color)
            }
        }
        .foregroundStyle(isActive ? activeColor : color)
        .frame(width: buttonSize, height: buttonSize)
   
        .contentShape(Rectangle())
        .opacity(isDisabled ? 0.2 : 1)
        .disabled(isDisabled)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            MainCircleButton(color: .lzWhite, image: .pencil) {
                print("White button tapped")
            }
            
            MainCircleButton(color: .lzAccent, image: .plus) {
                print("Accent button tapped")
            }
            
            MainCircleButton(color: .lzBlue, image: .checkmark) {
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
