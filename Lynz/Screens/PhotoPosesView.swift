//
//  PosesView.swift
//  Lynz
//
//  Created by Артур Кулик on 02.09.2025.
//

import SwiftUI

enum PoseCategory: CaseIterable, Identifiable {
    case standing
    case layingDown
    case sitting
    case closeUp
    
    var mainPhoto: ImageResource {
        switch self {
        case .standing:
            return .fullLenght
        case .layingDown:
            return .threeQuarter
        case .sitting:
            return .seatedPose
        case .closeUp:
            return .closeUp
        }
    }
    
    var name: String {
        switch self {
        case .standing:
            "Standing"
        case .layingDown:
            "Laying Down"
        case .sitting:
            "Sitting"
        case .closeUp:
            "Close-Up"
        }
    }
    
    var id: Self { self }
}

extension PoseCategory {
    var photosExmples: [ImageResource] {
        switch self {
        case .standing:
            return [
                .fullLenght,
                .fullLenght1,
                .fullLenght4,
                .fullLenght5,
                .fullLenght6,
                .fullLenght7,
                .fullLenght8,
                .fullLenght10
            ]
        case .layingDown:
            return [
                .threeQuaters7,
                .threeQuaters9,
                .threeQuaters10,
                .threeQuaters11,
                .threeQuaters12,
                .threeQuaters13,
                .threeQuaters14,
                .threeQuaters15
            ]
        case .sitting:
            return [
                .sitting1,
                .sitting2,
                .sitting3,
                .sitting4,
                .sitting5,
                .sitting6,
                .sitting7
            ]
        case .closeUp:
            return [
                .portrait1,
                .portrait2,
                .portrait3,
                .portrait4,
                .portrait5,
                .portrait6,
                .portrait7,
                .portrait8
            ]
        }
    }
}

struct PosesState {
    
}

enum PosesIntent {
    case tapPose(category: PoseCategory)
    case tapSettings
}

final class PosesViewStore: ViewStore<PosesState, PosesIntent> {
    
    override func reduce(state: inout PosesState, intent: PosesIntent) -> Effect<PosesIntent> {
        switch intent {
        case .tapPose(let category):
            return .navigate(.push(.poseLibrary(pose: category)))
        case .tapSettings:
            return .navigate(.fullScreenCover(.settings))
        }
    }
}


struct PhotoPosesView: View {
    var poses = PoseCategory.closeUp
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
            .padding(.bottom, .medium)
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
            ForEach(PoseCategory.allCases) { pose in
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
