//
//  NavigationBarExtensions.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI


// Модификатор который сохраняет поведение нативного NavBar при этом скрывает NavighationTitle, как в показано в дизайне
struct NavigationTitleStyleModifier: ViewModifier {
    let color: Color
    let fontSize: CGFloat
    @State private var originalAppearance: UINavigationBarAppearance?
    
    init(color: Color = .clear, fontSize: CGFloat = 17) {
        self.color = color
        self.fontSize = fontSize
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                applyNavigationTitleStyle()
            }
            .onDisappear {
//                restoreOriginalAppearance()
            }
    }
    
    private func applyNavigationTitleStyle() {
        guard let navigationController = findNavigationController() else { return }
        
        // Сохраняем оригинальные настройки
        originalAppearance = navigationController.navigationBar.standardAppearance.copy()
        
        // Создаём новые настройки
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(color),
            .font: UIFont.systemFont(ofSize: fontSize, weight: .ultraLight)
        ]
        
//        navigationController.navigationBar.standardAppearance = appearance
//        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func restoreOriginalAppearance() {
        guard let navigationController = findNavigationController(),
              let originalAppearance = originalAppearance else { return }
        
        navigationController.navigationBar.standardAppearance = originalAppearance
        navigationController.navigationBar.compactAppearance = originalAppearance
        navigationController.navigationBar.scrollEdgeAppearance = originalAppearance
    }
    
    private func findNavigationController() -> UINavigationController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return nil }
        
        return findNavigationController(in: window.rootViewController)
    }
    
    private func findNavigationController(in viewController: UIViewController?) -> UINavigationController? {
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for child in viewController?.children ?? [] {
            if let found = findNavigationController(in: child) {
                return found
            }
        }
        
        return nil
    }
}

extension View {
    /// /// Adjust inline navigation title
    func navigationTitleStyle(color: Color = .clear, fontSize: CGFloat = 17) -> some View {
        modifier(NavigationTitleStyleModifier(color: color, fontSize: fontSize))
    }
    
    /// Hide inline navigation title
    func hideInlineNavigationTitle() -> some View {
        navigationTitleStyle(color: .clear, fontSize: 2)
    }
}
