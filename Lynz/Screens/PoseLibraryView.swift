//
//  PoseLibraryView.swift
//  Lynz
//
//  Created by Артур Кулик on 02.09.2025.
//

import SwiftUI

struct PoseLibraryView: View {
    var pose: PoseCategory
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            screenHeader
                .padding(.top, .regular)
                .padding(.horizontal, .mediumExt)
                .padding(.bottom, .medium)
            photoLibrary
                .frame(height: 480) // высота фотографии в дизайне
                .padding(.bottom, .mediumExt)
            navigationPanel
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(BackgroundGradient().ignoresSafeArea())
    }
    
    var screenHeader: some View {
        ScreenHeaderView(title: pose.name) {
                HStack(spacing: 0) {
                    Text("\(currentIndex + 1)")
                    Text("/\(pose.photosExmples.count)")
                        .opacity(0.3)
                }
                .font(.lzTitle)
                .foregroundStyle(.lzWhite)
                .animation(nil, value: currentIndex)
            }
    }
    
    var photoLibrary: some View {
        GeometryReader { geometry in
            ZStack {
                // Кастомный TabView с анимацией
                HStack(spacing: .zero) {
                    ForEach(Array(pose.photosExmples.enumerated()), id: \.offset) { index, image in
                        AnimatedImageView(
                            image: image,
                            index: index,
                            currentIndex: currentIndex,
                            dragOffset: dragOffset,
                            screenWidth: geometry.size.width - 8, // padding -= 4(в дизайне) * 2 стороны
                            screenHeight: geometry.size.height,
                            isDragging: isDragging
                        )
                        .padding(.horizontal, 4)
                        .frame(width: geometry.size.width)
                    }
                }
                .offset(x: -CGFloat(currentIndex) * geometry.size.width + dragOffset)
                .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.8), value: currentIndex)
                .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            isDragging = false
                            let threshold: CGFloat = geometry.size.width * 0.3
                            
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                if value.translation.width > threshold && currentIndex > 0 {
                                    currentIndex -= 1
                                } else if value.translation.width < -threshold && currentIndex < pose.photosExmples.count - 1 {
                                    currentIndex += 1
                                }
                                dragOffset = 0
                            }
                        }
                )
                .clipped()
            }
        }
    }
    
    var navigationPanel: some View {
        HStack(spacing: .medium) {
            MainCircleButton(color: .lzYellow, image: .chevronLeft) {
                currentIndex = max(currentIndex - 1, 0)
            }
            MainCircleButton(color: .lzYellow, image: .chevronRight) {
                
                currentIndex = min(pose.photosExmples.count - 1, currentIndex + 1)
            }
        }
    }
}

struct AnimatedImageView: View {
    let image: ImageResource
    let index: Int
    let currentIndex: Int
    let dragOffset: CGFloat
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let isDragging: Bool
    
    private var relativePosition: CGFloat {
        let basePosition = CGFloat(index - currentIndex)
        let dragInfluence = dragOffset / screenWidth
        return basePosition - dragInfluence
    }
    
    private var scale: CGFloat {
        let distance = abs(relativePosition)
        
        // Плавное уменьшение в зависимости от расстояния от центра
        let baseScale = 1.0 - distance * 0.12
        
        // Ограничиваем минимальный размер
        return max(0.75, baseScale)
    }
    
    private var rotation: Double {
        let normalizedPosition = relativePosition
        return Double(normalizedPosition) * 8.0 // Увеличиваем поворот для более выраженного эффекта
    }
    
    private var opacity: Double {
        let distance = abs(relativePosition)
        
        // Плавное изменение прозрачности в зависимости от расстояния от центра
        let baseOpacity = 1.0 - distance * 0.4
        
        // Ограничиваем минимальную прозрачность
        return max(0.3, baseOpacity)
    }
    
    private var cornerRadius: CGFloat {
        let distance = abs(relativePosition)
        return 20 + distance * 15
    }
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth, height: 480)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .offset(x: relativePosition * screenWidth * 0.05) // Параллакс эффект
            .animation(
                isDragging ? 
                .interactiveSpring(response: 0.3, dampingFraction: 0.6) :
                .spring(response: 0.5, dampingFraction: 0.8),
                value: relativePosition
            )
    }
}

#Preview {
    PoseLibraryView(pose: .layingDown)
}
