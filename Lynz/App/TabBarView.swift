//
//  TabBarView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI

struct TabBarView: View {
    
    //Можно вынести в Coordinator при необходимост
    @State private var tabIndex: Int = 0
    
    init() {
        setupUITabBarAppearance()
    }
    
    var body: some View {
        content
    }
    
    var content: some View {
        nativeTabBar
            .overlay(alignment: .bottom) {
                designedTabBar
            }
    }
    
    var nativeTabBar: some View {
        TabView(selection: $tabIndex) {
            MessagesView()
                .tag(0)

            Text("Tab Content 2")
                .tag(1)
            
            Text("Tab Content 2")
                .tag(1)
        }
        .onAppear {

        }
    }
    
    var designedTabBar: some View {
        HStack(spacing: 0) {
            Group {
                TabBarButton(
                    icon: "messages",
                    isSelected: tabIndex == 0
                ) {
                    tabIndex = 0
                }
                
                TabBarButton(
                    icon: "users",
                    isSelected: tabIndex == 1
                ) {
                    tabIndex = 1
                }
                
                TabBarButton(
                    icon: "users",
                    isSelected: tabIndex == 1
                ) {
                    tabIndex = 1
                }
                
            }
            .frame(maxWidth: .infinity)
        }
        .background(
            backgroundBlurRounded
        )
    }
    
    private var backgroundBlurRounded: some View {
        Rectangle()
            .fill(.ultraThinMaterial) // Более сильный blur эффект
            .overlay { Color.lzTabBar.opacity(0.9) }
            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 30, topTrailing: 30)))
            .ignoresSafeArea(.all, edges: .bottom)
            .shadow(color: .black.opacity(0.1), radius: 20)
    }
    
    private func setupUITabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct TabBarButton: View {
    let icon: String
    let isSelected: Bool
    let selectedColor: Color = Color(.lzYellow)
    let unselectedColor: Color = .lzWhite.opacity(0.3)
    let action: () -> Void
    
    init(icon: String, isSelected: Bool, action: @escaping () -> Void) {
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .foregroundStyle(isSelected ? selectedColor : unselectedColor)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, .medium)
        .padding(.bottom, .small)
    }
}

#Preview {
    TabBarView()
}

// Применение явного размера для TabBar, чтобы у содержащих TabBar'а представлений были правильные нижние отступы.
extension UITabBar {
     override open func sizeThatFits(_ size: CGSize) -> CGSize {
         return CGSize(width: UIScreen.main.bounds.width, height: 88)
     }
 }

extension UITabBar {
}
