//
//  SelectableListItem.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

struct SelectableListItem: View {
    let text: String
    let radioButtonColor: Color
    let radioButtonStrokeWidth: CGFloat
    var isEditing: Bool
    let isSelected: Bool
    let onTap: () -> Void
    private let xMarkSize: CGFloat = 16
    private let radioButtonSize: CGFloat = 30
    
    var itemHeight: CGFloat {
        isEditing ? 50 : 30
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: .zero) {
                // Radio Button
                
                radioButton
                .padding(.trailing, 14)
                
                // Text
                Text(text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.lzWhite)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .bottom) {
                    SeparatorView(color: isEditing ? .lzGray : .clear)
                        .offset(y: 8)
                }
                Spacer(minLength: isEditing ? xMarkSize : .zero)
            }
            .overlay(alignment: .trailing) {
                deleteButton
            }
            .frame(height: itemHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var radioButton: some View {
        Group {
            if isSelected {
                Circle()
                    .fill(radioButtonColor)
            } else {
                Circle()
                    .stroke(radioButtonColor, lineWidth: radioButtonStrokeWidth)
            }
        }
        .frame(width: radioButtonSize, height: radioButtonSize)
    }
    
    var deleteButton: some View {
        Button {
            
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
