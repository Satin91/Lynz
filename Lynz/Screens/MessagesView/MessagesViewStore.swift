//
//  AllowTrackingViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation

final class MessagesViewStore: ViewStore<MessagesViewState, MessagesIntent> {
    
    private let permissionInteractor = Executor.perissionInteractor
    
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
        case .tapSettings:
            return .navigate(.fullScreenCover(.settings))
        case .showNotificationPermission:
            return .asyncTask { [weak self] in
                let result = await self?.permissionInteractor.requestNotificationPermissions()
                return .none
            }
        }
        return .none
    }
}

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
        
        var showNavigaionBar: Bool {
            switch self {
            case .notOnline:
                return false
            default: return true
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
    case tapSettings
    case showNotificationPermission
}
