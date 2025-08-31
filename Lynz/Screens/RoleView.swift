//
//  RoleView.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI


// Модель Role проектируется с учетом дальнейшего увеличения ролей: ретушер, визажист или еще кто-нибудь
enum Role: CaseIterable {
    case photographer
    case model
    
    // or localizedStringKey
    var name: String {
        switch self {
        case .photographer:
            return "photographer"
        case .model:
            return "model"
        }
    }
    
    var image: ImageResource {
        switch self {
        case .photographer:
            return .photographer
        case .model:
            return .model
        }
    }
}

struct RoleView: View {
    
    var body: some View {
        content
            .navigationTitle("Choose Role")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    var content: some View {
        ScrollView {
            rolesList
                .frame(maxHeight: .infinity)
                
        }
        .background(Color.gray.ignoresSafeArea(.all))
    }
    
    var rolesList: some View {
        VStack(spacing: .smallExt) {
            ForEach(Role.allCases, id: \.self) { role in
                makeRoleItem(role: role)
                    .onTapGesture {
                        Coordinator.shared.push(page: .role(CalendarDay(day: 7, isCurrentMonth: true, date: Date()) ))
                    }
            }
        }
    }
    
    func makeRoleItem(role: Role) -> some View {
        Image(role.image)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .bottom) {
                Text("I'm a " + role.name.capitalized)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.lzEmphasis)
                    .foregroundStyle(.lzBlack)
                    .padding(.vertical, .medium)
                    .padding(.leading, .mediumExt)
                    .background(Color.lzWhite)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
    }
    
}

#Preview {
    RoleView()
}
