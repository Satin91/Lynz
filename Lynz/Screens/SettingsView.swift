//
//  SettingsView.swift
//  Lynz
//
//  Created by Артур Кулик on 02.09.2025.
//

import SwiftUI




struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: .medium) {
            screenHeader
            settingsList
        }
        .padding(.horizontal, .mediumExt)
        .padding(.top, 40) // размер до ScreenHeaderView предыдущего View
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.lzYellow.ignoresSafeArea(.all))
    }
    
    var screenHeader: some View {
        ScreenHeaderView(title: "Settings", color: .lzBlack) {
            NavigationButton(imageName: .xMark, color: .lzBlack) {
                // dismiss
                dismiss()
            }
        }
    }
    
    var settingsList: some View {
        VStack {
            makeSettingsItem(text: "Contact Us", imageName: "phone.fill") { }
            makeSettingsItem(text: "Privacy Policy", imageName: "checkmark.shield.fill") { }
            makeSettingsItem(text: "Terms of use", imageName: "text.book.closed.fill") { }
            makeSettingsItem(text: "Privacy Settings", imageName: "lock.shield.fill") { }
            makeSettingsItem(text: "Permission Settings", imageName: "lock.doc.fill") { }
        }
    }
    
    func makeSettingsItem(text: String, imageName: String, onTap: @escaping () -> Void) -> some View {
        
        Button {
            onTap()
        } label: {
            HStack(spacing: .regular) {
                Image(systemName: imageName)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(.lzBlack.opacity(0.6))
                Text(text)
                    .font(.lzSubtitle)
                    .foregroundStyle(.lzBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.lzBlack.opacity(0.6))
            }
            .contentShape(Rectangle())
        }
        .frame(height: 68)
    }
}

#Preview {
    SettingsView()
}
