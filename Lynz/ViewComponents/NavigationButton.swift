//
//  NavigationSettingsButton.swift
//  Lynz
//
//  Created by Артур Кулик on 02.09.2025.
//

import SwiftUI

struct NavigationButton: View {
    enum ButtonImage: String {
        case xMark = "xmark"
        case gearShape = "gearshape"
    }
    
    var imageName: ButtonImage
    var color: Color
    var onTap: () -> Void
    
    var body: some View {
        Image(systemName: imageName.rawValue)
            .font(.title2)
            .foregroundStyle(color)
            .onTapGesture {
                onTap()
            }
    }
}

#Preview {
    VStack {
        NavigationButton(imageName: .gearShape, color: .lzWhite.opacity(0.6), onTap: {})
        NavigationButton(imageName: .xMark, color: .lzBlack.opacity(0.6), onTap: {})
    }
    .padding()
    .background(Color.gray)
}
