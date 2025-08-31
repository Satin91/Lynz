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
    let editButtonState: EditButtonState?
    let actionButtonState: ActionButtonState?
    let actionButtonIcon: String?
    
    let onEditButtonTap: (() -> Void)?
    let onActionButtonTap: (() -> Void)?
    
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
            
            // Кнопки справа (показываем только если они есть)
            if hasButtons {
                HStack(spacing: buttonSpacing) {
                    // Кнопка действия (вторая кнопка)
                    if let actionButtonIcon = actionButtonIcon,
                       let actionButtonState = actionButtonState,
                       let onActionButtonTap = onActionButtonTap {
                        CircleButton(
                            icon: actionButtonIcon,
                            isActive: actionButtonState.isActive,
                            action: onActionButtonTap
                        )
                    }
                    
                    // Кнопка редактирования (первая кнопка)
                    if let editButtonState = editButtonState,
                       let onEditButtonTap = onEditButtonTap {
                        CircleButton(
                            icon: editButtonState.icon,
                            isActive: editButtonState.isActive,
                            action: onEditButtonTap
                        )
                    }
                }
            }
        }
    }
    
    // Проверяем, есть ли хотя бы одна кнопка
    private var hasButtons: Bool {
        return (editButtonState != nil && onEditButtonTap != nil) ||
               (actionButtonState != nil && actionButtonIcon != nil && onActionButtonTap != nil)
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
    
    /// Инициализатор только с заголовком (без кнопок)
    init(title: String) {
        self.title = title
        self.editButtonState = nil
        self.actionButtonState = nil
        self.actionButtonIcon = nil
        self.onEditButtonTap = nil
        self.onActionButtonTap = nil
    }
    
    /// Инициализатор с кнопкой редактирования
    init(
        title: String,
        isEditing: Bool = false,
        onEdit: @escaping () -> Void
    ) {
        self.title = title
        self.editButtonState = isEditing ? .editing : .waiting
        self.actionButtonState = nil
        self.actionButtonIcon = nil
        self.onEditButtonTap = onEdit
        self.onActionButtonTap = nil
    }
    
    /// Инициализатор с кнопкой действия
    init(
        title: String,
        actionIcon: String,
        isActionActive: Bool = false,
        onAction: @escaping () -> Void
    ) {
        self.title = title
        self.editButtonState = nil
        self.actionButtonState = isActionActive ? .active : .inactive
        self.actionButtonIcon = actionIcon
        self.onEditButtonTap = nil
        self.onActionButtonTap = onAction
    }
    
    /// Полный инициализатор с обеими кнопками
    init(
        title: String,
        actionIcon: String,
        isEditing: Bool = false,
        isActionActive: Bool = false,
        onEdit: @escaping () -> Void,
        onAction: @escaping () -> Void
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
        // Только заголовок (без кнопок)
        ScreenHeaderView(title: "Простой заголовок")
        
        // Только кнопка редактирования
        ScreenHeaderView(
            title: "С редактированием",
            isEditing: false
        ) {
            print("Edit tapped")
        }
        
        // Только кнопка действия
        ScreenHeaderView(
            title: "С действием",
            actionIcon: "plus",
            isActionActive: true
        ) {
            print("Action tapped")
        }
        
        // Обе кнопки
        ScreenHeaderView(
            title: "Полный заголовок",
            actionIcon: "heart",
            isEditing: true,
            isActionActive: true,
            onEdit: {
                print("Edit tapped")
            },
            onAction: {
                print("Action tapped")
            }
        )
        
        Spacer()
    }
    .padding()
    .background(Color.lzGray)
}
