//
//  AllowTrackingView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI


struct AllowTrackingState {
    var isUserAgreedPermissions: Bool = false
}

enum AllowTrackingIntent {
    case showPermissions
    case toRootView
}

class AllowTrackingViewStore: ViewStore<AllowTrackingState, AllowTrackingIntent> {
    
    override func reduce(state: inout AllowTrackingState, intent: AllowTrackingIntent) -> Effect<AllowTrackingIntent> {
        
        switch intent {
        case .showPermissions:
            return .asyncTask {
                let status = await Executor.attService.requestPermissions()
                try! await Task.sleep(nanoseconds: 500_000_000) // чтобы была небольшая задержка для скрытия alert'a
                return .action(.toRootView)
            }
            
        case .toRootView:
            // AppState так же как и Coordinator может переехать во ViewStore
            AppState.shared.setOnboardingShown(isShown: true)
            AppState.shared.setAppViewState(.main)
        }
        return .none
    }
}

struct AllowTrackingView: View {
    
    @StateObject var store = AllowTrackingViewStore(initialState: .init())
    @State var circlesOffset: CGFloat = 139
    @State var showContent: Bool = false
    
    var body: some View {
        content
//        splashAnimation
            .navigationBarBackButtonHidden(true)
            .interactiveDismissDisabled()
            .onAppear {
                startCirclesAnimation()
            }
    }
    
    private func startCirclesAnimation() {
        withAnimation(.timingCurve(0.8, 0.0, 0.2, 1.0, duration: 0.8)) {
            circlesOffset = 0
        }
        
        // Показываем остальной контент после завершения анимации кругов
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
            withAnimation(.easeOut(duration: 0.4)) {
                showContent = true
            }
        }
    }
    
    
    var splashAnimation: some View {
        LayeredCircleView(contentType: .title("Lync"))
            .padding(.horizontal, 38)
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            Spacer()
            cicrles
                .offset(y: circlesOffset)
                .padding(.horizontal, 38)
                .padding(.bottom, 76)
            Group {
                
                title
                    .padding(.horizontal, .large)
                    .padding(.bottom, .medium)
                description
                    .padding(.horizontal, .large)
                    .padding(.bottom, .extraLarge)
                continueButton
                    .padding(.horizontal,.large)
                
            }
            .opacity(showContent ? 1.0 : 0.0)
        }
        .background(Color.lzYellow.ignoresSafeArea(.all))
    }
    
    var cicrles: some View {
        LayeredCircleView(contentType: .title("Lynz"))
    }
    
    var title: some View {
        Text("Security First: Your Safety \nMatters")
            .font(.lzSectionHeader)
            .kerning(-0.43)
            .multilineTextAlignment(.center)
            .foregroundStyle(.lzBlack)
    }
    
    var description: some View {
        Text(attributedDescription)
            .font(.lzSmall)
            .kerning(-0.43)
            .lineSpacing(7) // (Font Size / 2) = Font Size * 1.5 ( 150% in figma )
            .multilineTextAlignment(.center)
            .foregroundStyle(.lzBlack.opacity(0.4))
    }
    
    private var attributedDescription: AttributedString {
        var attributedString = AttributedString("We prioritize your security and believe in full transparency. Learn more about how we handle your data. By continuing, you confirm that you understand and accept our \nTerms of Service and Privacy Policy \nincluding EULA")
        
        if let termsRange = attributedString.range(of: "Terms of Service") {
            attributedString[termsRange].link = URL(string: "https://myaccount.google.com/termsofservice")!
            attributedString[termsRange].foregroundColor = .lzBlack
            attributedString[termsRange].underlineStyle = .single
        }
        
        if let privacyRange = attributedString.range(of: "Privacy Policy") {
            attributedString[privacyRange].foregroundColor = .lzBlack
            attributedString[privacyRange].link = URL(string: "https://policies.google.com/privacy?hl=ru")! // ссылка для Privacy Policy
            attributedString[privacyRange].underlineStyle = .single
        }
        
        return attributedString
    }
    
    var continueButton: some View {
        MainButtonView(title: "Continue", style: .capsuleFill(.lzBlack)) {
            store.send(.showPermissions)
        }
    }
}

#Preview {
    AllowTrackingView()
}
