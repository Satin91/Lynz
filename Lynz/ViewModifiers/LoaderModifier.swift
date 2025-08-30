//
//  LoaderModifier.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

struct LoaderModifier: ViewModifier {
    let isLoading: Bool
    @State private var showFullScreen = false
    @State private var opacity = 0.0

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $showFullScreen, content: loaderView)
            .transaction { $0.disablesAnimations = true }
            .onChange(of: isLoading) { handleLoadingChange($0) }
    }

    
    private func loaderView() -> some View {
        LoaderView()
            .opacity(opacity)
            .transparentBackground() // Кастоммный модификатор прозрачности для представлений, которые выше в стэке
            .onAppear(perform: animateOpacityIn)
    }
    
    private func handleLoadingChange(_ newValue: Bool) {
        if newValue {
            showFullScreen = true
        } else {
            animateOpacityOut()
        }
    }

    // Анимация появления
    private func animateOpacityIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 1
        }
    }
    
    // Анимация исчезновения
    private func animateOpacityOut() {
        withAnimation(.easeInOut(duration: 0.1)) {
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showFullScreen = false
        }
    }
}

extension View {
    /// Модификатор для отображения лоадера поверх всего интерфейса
    /// - Parameter isLoading: Булево значение, определяющее показывать ли лоадер
    func loader(isLoading: Bool) -> some View {
        modifier(LoaderModifier(isLoading: isLoading))
    }
}
