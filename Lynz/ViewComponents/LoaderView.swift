//
//  LoaderView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI
import Lottie


// Показывается через fullScreenCover
struct LoaderView: View {
    
    var body: some View {
        LottieView(animation: .named("loading"))
            .playing(loopMode: .loop)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay {
                Text("Loading...")
                    .font(.lzEmphasis)
                    .foregroundStyle(.lzBlack)
            }
            .background {
                Color.lzBlack.opacity(0.65).ignoresSafeArea(.all)
            }
            .ignoresSafeArea(.all)
    }
}
