//
//  Coordinator.swift
//  MVI_REDUX
//
//  Created by Артур Кулик on 15.08.2025.
//

import SwiftUI

enum Page: Hashable {
    case allowTrackingView
    
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .allowTrackingView:
            hasher.combine(UUID())
        }
    }
    
//    case chatsList(storage: ChatsStorageInteractorProtocol)
//    case chat(chat: ChatModelObserver)
//    case userSettings(appSettings: AppSettingsInteractor)
//    case cameraController(shotData: (Data) -> Void)
}

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    static let shared = Coordinator()
    

    func push(page: Page) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    @ViewBuilder func build(page: Page) -> some View {
        switch page {
        case .allowTrackingView:
            AllowTrackingViewView()
        default: EmptyView()
        }
    }
}
