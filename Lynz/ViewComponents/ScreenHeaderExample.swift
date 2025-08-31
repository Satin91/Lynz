//
//  ScreenHeaderExample.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

/// Пример использования ScreenHeaderView с управлением состоянием
struct ScreenHeaderExample: View {
    
    @State private var isEditing = false
    @State private var isActionActive = false
    
    var body: some View {
        VStack(spacing: .large) {
            // Заголовок с управляемым состоянием
            ScreenHeaderView(
                title: "Мои задачи",
                actionIcon: "plus",
                isEditing: isEditing,
                isActionActive: isActionActive
            ) {
                // Переключение режима редактирования
                withAnimation(.easeInOut(duration: 0.2)) {
                    isEditing.toggle()
                }
            } onAction: {
                // Переключение активности кнопки действия
                withAnimation(.easeInOut(duration: 0.2)) {
                    isActionActive.toggle()
                }
            }
            
            Spacer()
            
            // Демонстрационные кнопки
            VStack(spacing: .medium) {
                Text("Демонстрация состояний:")
                    .font(.lzSectionHeader)
                    .foregroundStyle(.lzWhite)
                
                Button("Переключить режим редактирования") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditing.toggle()
                    }
                }
                .padding(.medium)
                .background(Color.lzAccent)
                .foregroundStyle(.lzWhite)
                .cornerRadius(Layout.Radius.regular)
                
                Button("Переключить активность кнопки") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isActionActive.toggle()
                    }
                }
                .padding(.medium)
                .background(Color.lzBlue)
                .foregroundStyle(.lzWhite)
                .cornerRadius(Layout.Radius.regular)
            }
            
            Spacer()
        }
        .background(Color.lzGray.ignoresSafeArea())
    }
}

#Preview {
    ScreenHeaderExample()
}
