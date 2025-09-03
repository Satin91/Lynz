//
//  SeparatorView.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI


struct SeparatorView: View {
    let color: Color
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
    }
}
