//
//  TabBarView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var tabIndex: Int = 0
    
    var body: some View {
        content
    }
    
    var content: some View {
        tabView
    }
    
    var tabView: some View {
        TabView(selection: $tabIndex)  {
            Text("Tab Content 1").tabItem { Text("Tab Label 1") }.tag(0)
            Text("Tab Content 2").tabItem { Text("Tab Label 2") }.tag(1)
        }
    }
}
