//
//  ReadSize.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import Foundation

import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        onChange(geometry.size)
                    }
                    .onChange(of: geometry.size) { _, newSize in
                        onChange(newSize)
                    }
            }
        )
    }
}
