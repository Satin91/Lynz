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
    
    var navigationTitle: String {
        switch tabIndex {
        case 0: "Calendar"
        case 1: "Dialogs"
        case 2: "Photo Poses"
        default: ""
        }
    }
    
    init() {
        setupUITabBarAppearance()
    }
    var body: some View {
            content
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(tabIndex == 0 ? .large : .inline)
    }
    
    var content: some View {
        nativeTabBar
            .overlay(alignment: .bottom) {
                designedOverlay
            }
    }
    
    var nativeTabBar: some View {
        TabView(selection: $tabIndex) {
            CalendarView()
                .tag(0)
            MessagesView()
                .tag(1)
            PhotoPosesView()
                .tag(2)
        }
    }
    
    var designedOverlay: some View {
        HStack(spacing: 0) {
            Group {
                TabBarButton(
                    icon: .calendarTab,
                    isSelected: tabIndex == 0
                ) {
                    tabIndex = 0
                }
                
                TabBarButton(
                    icon: .messagesTab,
                    isSelected: tabIndex == 1
                ) {
                    tabIndex = 1
                }
                
                TabBarButton(
                    icon: .posesTab,
                    isSelected: tabIndex == 2
                ) {
                    tabIndex = 2
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
            .overlay { Color.lzGray.opacity(0.9) }
            .clipShape(.rect(cornerRadii: .init(topLeading: 30, topTrailing: 30)))
            .ignoresSafeArea(edges: .bottom)
            .shadow(color: .black.opacity(1), radius: 20)
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
    let icon: ImageResource
    let isSelected: Bool
    let selectedColor: Color = Color(.lzYellow)
    let unselectedColor: Color = .lzWhite.opacity(0.3)
    let action: () -> Void
    
    init(icon: ImageResource, isSelected: Bool, action: @escaping () -> Void) {
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Image(icon)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fill)
            .frame(width: 36, height: 36)
            .foregroundStyle(isSelected ? selectedColor : unselectedColor)
            .onTapGesture(perform: action)
            .padding(.top, .medium)
            .padding(.bottom, .regular)
    }
}

#Preview {
    TabBarView()
}

// Применение явного размера для TabBar, чтобы у содержащих TabBar'а представлений были правильные нижние отступы.
extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
}

extension UITabBar {
}
