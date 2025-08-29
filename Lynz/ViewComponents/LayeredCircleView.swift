//
//  LayeredCircleView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI

struct LayeredCircleView: View {
    
    enum CenterContent: Equatable {
        case title(String)
        case image(name: String)
    }
    
    @State private var circleSize: Double = 0
    
    private let contentType: CenterContent
    private let maxCircles: Int = 3
    
    init(contentType: CenterContent) {
        self.contentType = contentType
    }
    
    
    
    var body: some View {
        circles
            .frame(maxWidth: .infinity, maxHeight: circleSize)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            circleSize = proxy.size.width
                        }
                        .onChange(of: proxy.size) { oldValue, newValue in
                            circleSize = newValue.width
                        }

                }
            )
            .overlay {
                circlesOverlay
            }
    }
    
    
    @ViewBuilder
    var circlesOverlay: some View {
        switch contentType {
        case .title(let title):
            Text(title)
                .font(.lzHeader)
                .kerning(-2)
                .foregroundStyle(.lzYellow)
        case .image(let imageName):
            Image(imageName)
        }
    }
    
    var circles: some View {
        ZStack {
            
            ForEach(0..<maxCircles, id: \.self) { index in
                Circle()
                    .fill(color(for: index))
                    .frame(
                        width: circleSize * scale(for: index) ,
                        height: circleSize * scale(for: index)
                    )
            }
        }
    }
    
    private func scale(for index: Int) -> Double {
        1.0 - 0.15 * Double(index)
    }
    
    private func color(for index: Int) -> Color {
        Color.lzBlack.opacity(index == maxCircles - 1 ? 1 : 0.5)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        LayeredCircleView(contentType: .title("Lynz"))
        LayeredCircleView(contentType: .image(name: "messages"))
    }
    .background(Color("lzWhite"))
    .padding()
}

