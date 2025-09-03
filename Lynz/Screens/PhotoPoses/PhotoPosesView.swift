//
//  PosesView.swift
//  Lynz
//
//  Created by Артур Кулик on 02.09.2025.
//

import SwiftUI



struct PhotoPosesView: View {
    var poses = Pose.closeUp
    private let navigationTitle = "Photo Poses"
    
    @StateObject var store = PosesViewStore(initialState: .init())
    
    
    var body: some View {
        content
            .hideInlineNavigationTitle()
    }
    
    
    @ViewBuilder
    var content: some View {
        ScrollView {
            VStack(spacing: .medium) {
                screenHeader
                    .padding(.horizontal, .mediumExt)
                itemsGrid
            }
            .padding(.bottom, .large)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 1) // Временный костыль, который отделяет панель навигации от скрола, Т.К. в таб баре панель не накладывает блюр, решается.
        .background(BackgroundGradient().ignoresSafeArea(.all))
        .scrollIndicators(.hidden)
    }
    
    var itemsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4)
        ], spacing: 4) {
            ForEach(Pose.allCases) { pose in
                PoseCardView(title: pose.name, image: pose.mainPhoto, onButtonTap: {
                    store.send(.tapPose(category: pose))
                })
            }
        }
        .padding(.horizontal, .smallExt)
    }
    
    var screenHeader: some View {
        ScreenHeaderView(title: "Photo Poses") {
            NavigationButton(imageName: .gearShape, color: .lzWhite.opacity(0.6)) {
                store.send(.tapSettings)
            }
        }
    }
}

struct PoseCardView: View {
    var title: String
    var image: ImageResource
    var onButtonTap: () -> Void
    
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: 190, height: 310)
            .overlay(alignment: .bottom) {
                ZStack {
                    Rectangle()
                        .fill(.lzWhite)
                    text
                        .padding(.medium)
                    circleButton
                        .offset(y: -25)
                        .padding(.trailing, 14)
                }
                .frame(height: 54)
                .background(Color.white)
            }
        
            .clipShape(.rect(cornerRadius: 20))
        
    }
    
    var text: some View {
        Text(title)
            .font(.lzBodySmall)
            .foregroundStyle(.lzBlack)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
    }
    
    var circleButton: some View {
        Button {
            onButtonTap()
        } label: {
            Image(systemName: "arrow.right")
                .font(.lzBody)
                .foregroundStyle(.lzWhite)
                .padding(14)
                .frame(width: 50, height: 50)
                .background(Circle().fill(.lzBlack))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
}

#Preview {
    PhotoPosesView()
        .preferredColorScheme(.dark)
}
