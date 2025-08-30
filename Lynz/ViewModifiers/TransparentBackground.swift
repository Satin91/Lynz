//
//  TransparentBackground.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

// Вспомогательный View для прозрачного фона fullScreenCover
struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
        
    }
}


extension View {
    func transparentBackground() -> some View {
        self.background(ClearBackgroundView())
    }
}
