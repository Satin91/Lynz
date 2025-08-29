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
//        ZStack {
            tabView
            .overlay(alignment: .bottom) {
                customTabBar
//                    .ignoresSafeArea(.all)
            }
    }
    
    var tabView: some View {
        TabView(selection: $tabIndex) {
            MessagesView()
                .tabItem { 
                    // Делаем нативные табы невидимыми
                    EmptyView()
                }
                .tag(0)
            
            Text("Tab Content 2")
                .tabItem { 
                    EmptyView()
                }
                .tag(1)
        }
        .onAppear {
            // Делаем нативный TabBar прозрачным
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.clear
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var customTabBar: some View {
        HStack(spacing: 0) {
            Spacer()
            TabBarButton(
                icon: "messages",
                isSelected: tabIndex == 0
            ) {
                tabIndex = 0
            }
            Spacer()
            TabBarButton(
                icon: "users",
                isSelected: tabIndex == 1
            ) {
                tabIndex = 1
            }
            Spacer()
        }
        .background(Color.lzTabBar)
        .clipShape(TopRoundedRectangle(cornerRadius: 20))
    }
}

struct TabBarButton: View {
    let icon: String
    let isSelected: Bool
    let selectedColor: Color = Color(.lzYellow)
    let unselectedColor: Color = Color(.lzWhite.opacity(0.3))
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
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .foregroundStyle(isSelected ? selectedColor : unselectedColor)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, .medium)
    }
}

#Preview {
    TabBarView()
}

// Кастомная форма для обрезки только верхних углов
struct TopRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        // Начинаем с левого нижнего угла
        path.move(to: CGPoint(x: 0, y: height))
        
        // Левая сторона до начала скругления
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        // Левый верхний скругленный угол
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                   radius: cornerRadius,
                   startAngle: Angle(degrees: 180),
                   endAngle: Angle(degrees: 270),
                   clockwise: false)
        
        // Верхняя сторона
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        
        // Правый верхний скругленный угол
        path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                   radius: cornerRadius,
                   startAngle: Angle(degrees: 270),
                   endAngle: Angle(degrees: 0),
                   clockwise: false)
        
        // Правая сторона
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Нижняя сторона (прямая)
        path.addLine(to: CGPoint(x: 0, y: height))
        
        return path
    }
}

extension UITabBar {
     override open func sizeThatFits(_ size: CGSize) -> CGSize {
         return CGSize(width: UIScreen.main.bounds.width, height: 50)
     }
 }
