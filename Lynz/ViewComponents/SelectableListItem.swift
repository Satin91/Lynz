//
//  SelectableListItem.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI



extension SelectableListItem {
    
    init(role: Role, task: TaskCategory, isEditing: Bool, isSingleFocused: Bool, onTap: @escaping () -> Void, onTapDelete: @escaping () -> Void, onTextChange: @escaping (String) -> Void) {
        text = task.name
        tintColor = role.tint
        isSelected = task.isActive
        self.isEditing = isEditing
        self.onTap = onTap
        self.onTapDelete = onTapDelete
        switch role {
        case .photographer:
            radioButtonOpacity = 0.4
            radioButtonStrokeWidth = 1.4
        case .model:
            radioButtonOpacity = 0.3
            radioButtonStrokeWidth = 1
        }
        
        self._editableText = Binding(
            get: { task.name },
            set: { text in onTextChange(text) }
        )
        self.isSingleFocused = isSingleFocused
    }
}

struct SelectableListItem: View {
    let text: String
    let tintColor: Color
    let radioButtonStrokeWidth: CGFloat
    var isEditing: Bool
    let isSelected: Bool
    var radioButtonOpacity: CGFloat
    let onTap: () -> Void
    let onTapDelete: () -> Void
    var isSingleFocused: Bool
    @Binding var editableText: String
    @FocusState var isFocused
    private let xMarkSize: CGFloat = 16
    private let radioButtonSize: CGFloat = 30
    
    
    // Обший инициализатор для переиспользования
    init(
        text: String,
        radioButtonColor: Color,
        radioButtonStrokeWidth: CGFloat,
        isEditing: Bool,
        isSelected: Bool,
        onTap: @escaping () -> Void,
        onTapDelete: @escaping () -> Void,
        onTextChange: ((String) -> Void)? = nil
    ) {
        self.text = text
        self.tintColor = radioButtonColor
        self.radioButtonStrokeWidth = radioButtonStrokeWidth
        self.isEditing = isEditing
        self.isSelected = isSelected
        self.onTap = onTap
        self.onTapDelete = onTapDelete
        self.radioButtonOpacity = 0.3
        self._editableText = Binding(
            get: { text },
            set: { text in onTextChange?(text) }
        )
        self.isSingleFocused = false
    }
    
    var itemHeight: CGFloat {
        isEditing ? 50 : 30
    }
    
    var body: some View {
        Button(action: !isEditing ? onTap : {}) {
            HStack(spacing: .zero) {
                // Radio Button
                radioButton
                    .padding(.trailing, 14)
                textField
                Spacer(minLength: isEditing ? xMarkSize : .zero)
            }
            .overlay(alignment: .trailing) {
                deleteButton
            }
            .frame(height: itemHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onChange(of: isSingleFocused) { newValue in
            print("DEBUG: new value \(newValue)")
        }
    }
    
    var textField: some View {
        TextField("", text: $editableText)
            .focused($isFocused)
            .tint(tintColor)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.lzWhite)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .disabled(!isEditing)
            .overlay(alignment: .bottom) {
                SeparatorView(color: isFocused ? tintColor : .lzGray)
                    .opacity(isEditing ? 1 : 0)
                    .offset(y: 8)
            }
    }
    
    var radioButton: some View {
        Group {
            if isSelected {
                Circle()
                    .fill(tintColor)
            } else {
                Circle()
                    .stroke(tintColor, lineWidth: radioButtonStrokeWidth)
            }
        }
        .opacity(isEditing ? radioButtonOpacity : 1)
        .frame(width: radioButtonSize, height: radioButtonSize)
    }
    
    var deleteButton: some View {
        Button {
            onTapDelete()
        } label: {
            Color.clear
                .frame(width: xMarkSize, height: xMarkSize)
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 17))
                        .foregroundColor(.lzWhite)
                }
                .opacity(isEditing ? 1 : 0)
                .offset(x: isEditing ? 0 : xMarkSize)
        }
    }
}

#Preview {
    VStack {
        SelectableListItem(text: "Some text", radioButtonColor: .accentColor, radioButtonStrokeWidth: 1.4, isEditing: true, isSelected: false, onTap: { }, onTapDelete: { }, onTextChange: { newText in
            print("Text changed to: \(newText)")
        })
        SelectableListItem(text: "Some text", radioButtonColor: .accentColor, radioButtonStrokeWidth: 1.4, isEditing: false, isSelected: true, onTap: { }, onTapDelete: { }, onTextChange: { newText in
            print("Text changed to: \(newText)")
        })
    }
    .padding(.horizontal, .mediumExt)
    .frame(maxHeight: .infinity)
    .background(BackgroundGradient().ignoresSafeArea(.all))
}
