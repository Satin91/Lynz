//
//  NotificationAuthorizationView.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import SwiftUI

struct NotificationAuthorizationView: View {
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: .zero) {
//            Spacer()
            cicrles
                .padding(.horizontal, 38)
                .padding(.bottom, 76)
            title
                .padding(.horizontal, .large)
                .padding(.bottom, .medium)
            description
                .padding(.horizontal, .large)
                .padding(.bottom, .extraLarge)
            continueButton
                .padding(.horizontal,.large)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .background(Color.lzYellow.ignoresSafeArea(.all, edges: .all))
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
            
        }
    }
}

#Preview {
    NotificationAuthorizationView()
}
