//
//  ContentView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI

struct MainView: View {
    @StateObject var coordinator = Coordinator.shared
    @StateObject var appState = AppState.shared
    @State var selection: Int = 0
    
    
    var body: some View {
        switch appState.viewState {
        case .splash:
            Text("Splash")
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        appState.setAppViewState(.onboarding)
                    })
                }
        case .onboarding:
            AllowTrackingView()
        case .main:
            mainContent
        }
    }
    
    
    var mainContent: some View {
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
        }
        .fullScreenCover(item: $coordinator.presentedPage) { page in
            coordinator.build(page: page)
        }
    }
    
    var content: some View {
        let page = TestEnvironment.forcePage(test: .shootPlan(Plan.stub), original: .root)
        return coordinator.build(page: page)
    }
}

#Preview {
    MainView()
}
