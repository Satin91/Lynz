//
//  BackgroundGradient.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.lzGraySecondary, Color.lzGrayTertiary]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
