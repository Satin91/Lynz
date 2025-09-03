//
//  MessagesView.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import SwiftUI
import Lottie


struct MessagesView: View {
    
    private let sirclesSize: CGFloat = 258
    @StateObject private var store = MessagesViewStore(initialState: MessagesViewState())
    
    var body: some View {
        content
            .preferredColorScheme(.light)
            .loader(isLoading: store.state.isLoading)
            .hideInlineNavigationTitle()
            .onAppear {
                store.send(.showNotificationPermission)
            }
    }
    
    var content: some View {
        VStack {
            screenHeader
                .opacity(store.state.viewState.showNavigaionBar ? 1 : 0)
                .padding(.horizontal, .mediumExt)
            makeViewStateContainer()
        }
        .background(Color.lzYellow.ignoresSafeArea(.all))
    }
    
    
    
    @ViewBuilder
    func makeViewStateContainer() -> some View {
        let currentState = store.state.viewState
        
        if currentState.showDefaultContainer {
            makeStubContainer(
                title: currentState.title,
                description: currentState.description,
                image: currentState.image,
                buttonText: currentState.buttonText
            )
        } else {
            // Представление с пользователями в сети
            makeUsersOnlineView()
        }
    }
    
    func makeUsersOnlineView() -> some View {
        VStack {
            Text("Users are online!")
                .font(.lzSectionHeader)
                .foregroundStyle(.lzBlack)
            // Здесь будет список пользователей
        }
    }
    
    func makeStubContainer(
        title: String,
        description: String,
        image: ImageResource,
        buttonText: String
    ) -> some View {
        let currentState = store.state.viewState
        
        return VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                LayeredCircleView(contentType: .image(image))
                    .font(.lzBody)
                    .frame(width: sirclesSize, alignment: .center)
                    .padding(.bottom, .extraLargeExt)
                TextColumn(
                    title: title.capitalized,
                    description: description)
                .padding(.horizontal, .extraLargeExt)
            }
            .padding(.top, .extraLarge)
            .frame(maxHeight: .infinity, alignment: .top)
            
            MainButtonView(title: buttonText.capitalized, style: .roundedFill(.white)) {
                store.send(currentState.buttonAction)
            }
            .padding(.horizontal, .large)
            .padding(.bottom, .huge)
        }
    }
    
    var screenHeader: some View {
        ScreenHeaderView(title: "Dialogs", color: .lzBlack) {
            NavigationButton(imageName: .gearShape, color: .lzBlack.opacity(0.6)) {
                store.send(.tapSettings)
            }
        }
    }
    
    struct TextColumn: View {
        let title: String
        let description: String
        
        var body: some View {
            VStack(spacing: .regular) {
                Text(title)
                    .font(.lzSectionHeader, lineHeight: 14)
                Text(description)
                    .font(.lzSmall, lineHeight: 20)
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(.lzBlack)
        }
    }
    
}

#Preview {
    MessagesView()
}
