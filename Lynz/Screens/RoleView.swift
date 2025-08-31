//
//  RoleView.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

struct RoleState {
    var day: CalendarDay
    
}

enum RoleIntent {
    case tapRole(role: Role)
}

final class RoleViewStore: ViewStore<RoleState, RoleIntent> {
    
    override func reduce(state: inout RoleState, intent: RoleIntent) -> Effect<RoleIntent> {
        
        switch intent {
        case .tapRole(let role):
            push(.shootPlan(role))
        }
        
        return .none
    }
}

struct RoleView: View {
    
    private let navTitle = "Choose you role"
    
    @StateObject var store: RoleViewStore
    
    init(day: CalendarDay) {
        _store = StateObject(wrappedValue: RoleViewStore(initialState: .init(day: day)))
    }
    
    var body: some View {
        content
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .hideInlineNavigationTitle()
    }
    
    var content: some View {
        ScrollView {
            VStack {
                screenHeader
                rolesList
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, .mediumExt)
        .background(Color.gray.ignoresSafeArea(.all))
    }
    
    
    var screenHeader: some View {
        VStack(spacing: .regular) {
            ScreenHeaderView(title: navTitle)
            EventRoleDescription(date: store.state.day.date)
        }
    }
    
    var rolesList: some View {
        VStack(spacing: .smallExt) {
            ForEach(Role.allCases, id: \.self) { role in
                makeRoleCard(role: role)
                    .onTapGesture {
                        store.send(.tapRole(role: role))
                    }
            }
        }
    }
    
    func makeRoleCard(role: Role) -> some View {
        Image(role.defaultPhoto)
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
    RoleView(day: .stub)
}
