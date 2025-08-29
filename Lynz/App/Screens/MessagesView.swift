//
//  MessagesView.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import SwiftUI

struct MessagesViewState {
    
}

enum MessagesIntent {
    case connect
    
}

final class MessagesViewStore: ViewStore<MessagesViewState, MessagesIntent> {
    
    override func reduce(state: inout MessagesViewState, intent: MessagesIntent) -> Effect<MessagesIntent> {
        
        
        switch intent {
        case .connect:
            break
        }
        
        
        return .none
    }
}

struct MessagesView: View {
    
    private let sirclesSize: CGFloat = 258
    
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            
            VStack(spacing: .zero) {
                LayeredCircleView(contentType: .image(name: "messages"))
                    .font(.lzBody)
                    .frame(width: sirclesSize, alignment: .center)
                    .padding(.bottom, .extraLargeExt)
                TextColumn(
                    title: "Others are ready — just go online".capitalized,
                    description: "The moment you're connected, chats will appear here")
                .padding(.horizontal, .extraLargeExt)
            }
            .frame(maxHeight: .infinity)
            
            MainButtonView(title: "Go Online", style: .roundedFill(.white)) {
                
            }
            .padding(.horizontal, .large)
//            .padding(.bottom, .huge)
        }
        .background(Color.lzYellow.ignoresSafeArea(.all))
    }
    
    struct TextColumn: View {
        let title: String
        let description: String
        
        var body: some View {
            VStack(spacing: .regular) {
                Text(title)
                    .font(.lzSectionHeader, lineHeight: 14)
                Text(description)
                    .font(.lzSmall, lineHeight: 20)
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(.lzBlack)
        }
    }
}

#Preview {
    MessagesView()
}

//
//  LineHeight.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import SwiftUI

extension View {
    /// Устанавливает высоту строки для текста
    /// - Parameter height: Желаемая высота строки
    /// - Returns: Модифицированный View с установленной высотой строки
    func lineHeight(_ height: CGFloat) -> some View {
        self.lineSpacing(height - UIFont.systemFont(ofSize: 17).lineHeight)
    }
    
    /// Устанавливает высоту строки для текста с учетом размера шрифта
    /// - Parameters:
    ///   - height: Желаемая высота строки
    ///   - fontSize: Размер шрифта для правильного расчета
    /// - Returns: Модифицированный View с установленной высотой строки
    func lineHeight(_ height: CGFloat, fontSize: CGFloat) -> some View {
        let systemFont = UIFont.systemFont(ofSize: fontSize)
        let spacing = height - systemFont.lineHeight
        return self.lineSpacing(max(0, spacing))
    }
    
    /// Устанавливает фиксированную высоту строки независимо от размера шрифта
    /// - Parameter height: Фиксированная высота строки (20pt)
    /// - Returns: Модифицированный View с фиксированной высотой строки
    func fixedLineHeight(_ height: CGFloat = 20) -> some View {
        self.environment(\.lineSpacing, height - 17) // 17 - стандартная высота системного шрифта
    }
}

// MARK: - Дополнительные модификаторы для удобства
extension Text {
    /// Быстрый способ установить высоту строки 20pt
    func standardLineHeight() -> some View {
        self.lineHeight(20, fontSize: 17)
    }
}
