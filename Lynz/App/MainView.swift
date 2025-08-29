//
//  ContentView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI

struct MainView: View {
    @StateObject var coordinator = Coordinator.shared
    
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
        }
    }
    
    
    var content: some View {
        TabBarView()
//        coordinator.build(page: .allowTrackingView)
    }
    
    
}

#Preview {
    MainView()
}
