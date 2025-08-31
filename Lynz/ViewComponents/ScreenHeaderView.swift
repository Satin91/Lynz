//
//  ScreenHeaderView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

// MARK: - Button States
enum EditButtonState {
    case waiting    // Ожидающее состояние (обычное)
    case editing    // Режим редактирования
    
    var icon: String {
        switch self {
        case .waiting:
            return "pencil"
        case .editing:
            return "checkmark"
        }
    }
    
    var isActive: Bool {
        switch self {
        case .waiting:
            return false
        case .editing:
            return true
        }
    }
}

enum ActionButtonState {
    case inactive   // Неактивная кнопка
    case active     // Активная кнопка
    
    var isActive: Bool {
        switch self {
        case .inactive:
            return false
        case .active:
            return true
        }
    }
}

// MARK: - Screen Header View
struct ScreenHeaderView: View {
    
    // MARK: - Properties
    let title: String
    let editButtonState: EditButtonState
    let actionButtonState: ActionButtonState
    let actionButtonIcon: String
    
    let onEditButtonTap: () -> Void
    let onActionButtonTap: () -> Void
    
    // MARK: - Configuration
    private let buttonSize: CGFloat = 44
    private let buttonSpacing: CGFloat = 12
    
    var body: some View {
        HStack {
            // Заголовок
            Text(title)
                .font(.lzTitle)
                .foregroundStyle(.lzWhite)
            
            Spacer()
            
            // Кнопки справа
            HStack(spacing: buttonSpacing) {
                // Кнопка действия (вторая кнопка)
                CircleButton(
                    icon: actionButtonIcon,
                    isActive: actionButtonState.isActive,
                    action: onActionButtonTap
                )
                
                // Кнопка редактирования (первая кнопка)
                CircleButton(
                    icon: editButtonState.icon,
                    isActive: editButtonState.isActive,
                    action: onEditButtonTap
                )
            }
        }
        .padding(.horizontal, .mediumExt)
    }
}

// MARK: - Circle Button Component
private struct CircleButton: View {
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    private let buttonSize: CGFloat = 44
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.lzBody)
                .foregroundStyle(.lzWhite)
                .frame(width: buttonSize, height: buttonSize)
                .background(
                    Circle()
                        .stroke(.lzWhite, lineWidth: 1)
                        .foregroundStyle(isActive ? Color.lzAccent : Color.clear)
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

// MARK: - Convenience Initializers
extension ScreenHeaderView {
    
    /// Упрощенный инициализатор для быстрого использования
    init(
        title: String,
        actionIcon: String,
        isEditing: Bool = false,
        isActionActive: Bool = false,
        onEdit: @escaping () -> Void = {},
        onAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.editButtonState = isEditing ? .editing : .waiting
        self.actionButtonState = isActionActive ? .active : .inactive
        self.actionButtonIcon = actionIcon
        self.onEditButtonTap = onEdit
        self.onActionButtonTap = onAction
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        // Обычное состояние
        ScreenHeaderView(
            title: "Заголовок экрана",
            actionIcon: "plus",
            isEditing: false,
            isActionActive: false
        ) {
            print("Edit tapped")
        } onAction: {
            print("Action tapped")
        }
        
        // Режим редактирования
        ScreenHeaderView(
            title: "Режим редактирования",
            actionIcon: "plus",
            isEditing: true,
            isActionActive: true
        ) {
            print("Done tapped")
        } onAction: {
            print("Add tapped")
        }
        
        // Только активная кнопка действия
        ScreenHeaderView(
            title: "Активная кнопка",
            actionIcon: "heart",
            isEditing: false,
            isActionActive: true
        ) {
            print("Edit tapped")
        } onAction: {
            print("Heart tapped")
        }
        
        Spacer()
    }
    .padding()
    .background(Color.lzGray)
}
