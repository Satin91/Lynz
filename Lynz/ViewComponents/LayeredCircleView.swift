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
        case image(ImageResource)
    }
    
    @State private var circleSize: Double = 0
    private let contentType: CenterContent
    private let maxCircles: Int = 3
    
    init(contentType: CenterContent) {
        self.contentType = contentType
    }
    
    var body: some View {
        ZStack {
            circles
                .frame(maxWidth: .infinity, maxHeight: circleSize)
                .readSize { circleSize = $0.width }
            
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
                .foregroundStyle(Color.lzYellowOptimized)
        case .image(let image):
            Image(image)
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
        1.0 - 0.12 * Double(index)
    }
    
    private func color(for index: Int) -> Color {
        Color.lzBlack.opacity(index == maxCircles - 1 ? 1 : 0.5)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        LayeredCircleView(contentType: .title("Lynz"))
        LayeredCircleView(contentType: .image(.messages))
    }
    .background(Color("lzWhite"))
    .padding()
}


// Этот цвет нужен для оптимизации анимации текста. Будучи статическим свойством, он применяется мнгновенно, в отличии от цветов из ресурсов, которые вычисляются в просессе отрисовки ( когда анимация была уже запущена ) с помощью foregroundStyle, который имеет более широкие возможности чем просто цвет. Так же решением может послужить вызвать цвет черех .foregroundColor, но он deprecated.
extension Color {
    static let lzYellowOptimized = Color.lzYellow
}
