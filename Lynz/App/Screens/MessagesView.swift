//
//  MessagesView.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import SwiftUI
import Lottie

struct MessagesViewState {
    enum ViewState {
        case notOnline
        case online(isEmpty: Bool)
        
        // MARK: - Computed Properties
        var title: String {
            switch self {
            case .notOnline:
                return "Others are ready — just go online"
            case .online(isEmpty: true):
                return "No users online"
            case .online(isEmpty: false):
                return "Users online"
            }
        }
        
        var description: String {
            switch self {
            case .notOnline:
                return "The moment you're connected, chats will appear here"
            case .online(isEmpty: true):
                return "Please wait a little, or in the meantime, you can explore our photo pose library or plan your shoot"
            case .online(isEmpty: false):
                return "Select a user to start chatting"
            }
        }
        
        var image: ImageResource {
            switch self {
            case .notOnline:
                return .messages
            case .online(isEmpty: true):
                return .users
            case .online(isEmpty: false):
                return .users
            }
        }
        
        var buttonText: String {
            switch self {
            case .notOnline:
                return "Go Online"
            case .online(isEmpty: true):
                return "End Session"
            case .online(isEmpty: false):
                return "Refresh"
            }
        }
        
        var buttonAction: MessagesIntent {
            switch self {
            case .notOnline:
                return .connect
            case .online(isEmpty: true):
                return .endSession
            case .online(isEmpty: false):
                return .refreshUsers
            }
        }
        
        var showDefaultContainer: Bool {
            switch self {
            case .notOnline, .online(isEmpty: true):
                return true
            case .online(isEmpty: false):
                return false
            }
        }
    }
    
    var isLoading: Bool = false
    var viewState: ViewState = .notOnline
}

enum MessagesIntent {
    case connect
    case toggleLoader
    case endSession
    case refreshUsers
    case setViewState(MessagesViewState.ViewState)
}

final class MessagesViewStore: ViewStore<MessagesViewState, MessagesIntent> {
    
    override func reduce(state: inout MessagesViewState, intent: MessagesIntent) -> Effect<MessagesIntent> {
        switch intent {
        case .connect:
            state.isLoading = true
            return .asyncTask {
                try! await Task.sleep(nanoseconds: 2_000_000_000)
                return .sequence([
                    .toggleLoader,
                    .setViewState(.online(isEmpty: true))
                ])
            }
            
        case .endSession:
            state.isLoading = true
            return .asyncTask {
                try! await Task.sleep(nanoseconds: 1_000_000_000) // 1 секунда
                return .sequence([
                    .toggleLoader,
                    .setViewState(.notOnline)
                ])
            }
            
        case .refreshUsers:
            state.isLoading = true
            return .asyncTask {
                try! await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 секунды
                // Симуляция: иногда находим пользователей, иногда нет
                let hasUsers = Bool.random()
                return .sequence([
                    .toggleLoader,
                    .setViewState(.online(isEmpty: !hasUsers))
                ])
            }
            
        case .toggleLoader:
            state.isLoading.toggle()
            
        case .setViewState(let viewState):
            state.viewState = viewState
        }
        
        return .none
    }
}

struct MessagesView: View {
    
    private let sirclesSize: CGFloat = 258
    @StateObject private var store = MessagesViewStore(initialState: MessagesViewState())
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Dialogs")
                .loader(isLoading: store.state.isLoading)
        }
    }
    
    var content: some View {
        makeViewStateContainer()
            .background(Color.lzYellow.ignoresSafeArea(.all))
    }

    
    
    @ViewBuilder
    func makeViewStateContainer() -> some View {
        let currentState = store.state.viewState
        
        if currentState.showDefaultContainer {
            makeDefaultContainer(
                title: currentState.title,
                description: currentState.description,
                image: currentState.image,
                buttonText: currentState.buttonText
            )
        } else {
            // Представление с пользователями в сети
            makeUsersOnlineView()
        }
    }
    
    func makeUsersOnlineView() -> some View {
        VStack {
            Text("Users are online!")
                .font(.lzSectionHeader)
                .foregroundStyle(.lzBlack)
            // Здесь будет список пользователей
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func makeDefaultContainer(
        title: String,
        description: String,
        image: ImageResource,
        buttonText: String
    ) -> some View {
        let currentState = store.state.viewState
        
        return VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                LayeredCircleView(contentType: .image(image))
                    .font(.lzBody)
                    .frame(width: sirclesSize, alignment: .center)
                    .padding(.bottom, .extraLargeExt)
                TextColumn(
                    title: title.capitalized,
                    description: description)
                .padding(.horizontal, .extraLargeExt)
            }
            .padding(.top, .extraLarge)
            .frame(maxHeight: .infinity, alignment: .top)
            
            MainButtonView(title: buttonText.capitalized, style: .roundedFill(.white)) {
                store.send(currentState.buttonAction)
            }
            .padding(.horizontal, .large)
            .padding(.bottom, .huge)
        }
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

