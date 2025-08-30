//
//  MessagesView.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import SwiftUI
import Lottie

struct MessagesViewState {
    var isLoading: Bool = false
}

enum MessagesIntent {
    case connect
    case toggleLoader
}

final class MessagesViewStore: ViewStore<MessagesViewState, MessagesIntent> {
    
    override func reduce(state: inout MessagesViewState, intent: MessagesIntent) -> Effect<MessagesIntent> {
        switch intent {
        case .connect:
            state.isLoading = true
            // Симуляция загрузки
            return .asyncTask {
                try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 секунды
                return .action(.toggleLoader)
            }
        case .toggleLoader:
            state.isLoading.toggle()
        }
        
        return .none
    }
}

struct MessagesView: View {
    
    private let sirclesSize: CGFloat = 258
    @StateObject private var store = MessagesViewStore(initialState: MessagesViewState())
    
    var body: some View {
        content
            .loader(isLoading: store.state.isLoading)
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
            
            VStack(spacing: .medium) {
                MainButtonView(title: "Go Online", style: .roundedFill(.white)) {
                    store.send(.connect)
                }
                
                // Кнопка для тестирования лоадера
                Button("Toggle Loader") {
                    store.send(.connect)
                }
                .font(.lzBody)
                .foregroundStyle(.lzBlack)
                .padding(.horizontal, .large)
                .padding(.vertical, .small)
                .background(Color.white.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, .large)
            .padding(.bottom, .huge)
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

