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
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                        
                }
        }
    }
    
    
    @ViewBuilder
    var controlsLayer: some View {
        if appState.isShowLoader {
            LoaderView()
        }
    }
    
    var content: some View {
        TabBarView()
//            .environmentObject(coordinator)
//        coordinator.build(page: .allowTrackingView)
    }
    
    
}

#Preview {
    MainView()
}
