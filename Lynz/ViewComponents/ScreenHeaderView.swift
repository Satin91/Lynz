//
//  ScreenHeaderView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

// MARK: - Screen Header View
struct ScreenHeaderView<Content: View>: View {
    
    // MARK: - Properties
    let title: String
    let content: Content
    var color: Color
    
    // MARK: - Configuration
    private let buttonSpacing: CGFloat = 12
    
    var body: some View {
        HStack {
            Text(title)
                .font(.lzTitle)
                .foregroundStyle(color)
            
            Spacer()
            // Content блок для кнопок
            content
        }
    }
}

// MARK: - Convenience Initializers
extension ScreenHeaderView {
    
    /// Инициализатор только с заголовком (без кнопок)
    init(title: String, color: Color = .lzWhite) where Content == EmptyView {
        self.title = title
        self.color = color
        self.content = EmptyView()
    }
    
    /// Инициализатор с заголовком и content блоком для кнопок
    init(
        title: String,
        color: Color = .lzWhite,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.color = color
        self.content = content()
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        // Только заголовок
        ScreenHeaderView(title: "Простой заголовок")
        
        // С пользовательскими кнопками
        ScreenHeaderView(title: "С кнопками") {
            HStack(spacing: 8) {
                MainCircleButton(color: .lzGray, image: .checkmark) {
                    print("Gray button tapped")
                }
                MainCircleButton(color: .lzWhite, image: .pencil) {
                    print("White button tapped")
                }
            }
        }
        
        Spacer()
    }
    .padding()
    .background(Color.lzGray)
}


