//
//  ShootPlanView.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import SwiftUI

struct ShootPlanState {
    var role: Role
    
    init(role: Role) {
        self.role = role
    }
}

enum ShootPlanIntent {
    
}

final class ShootPlanViewStore: ViewStore<ShootPlanState, ShootPlanIntent> {
    
}


struct ShootPlanView: View {
    @StateObject var store: ShootPlanViewStore
    private let navTitle = "Shoot Plan"
    
    
    init(role: Role) {
        _store = StateObject(wrappedValue: ShootPlanViewStore(initialState: .init(role: role)))
    }
    
    var body: some View {
        content
            .navigationTitle(navTitle) // На случай если в будущем будет переход из этого экрана
    }
    
    
    var content: some View {
        Text(store.state.role.name)
    }
}

#Preview {
    ShootPlanView(role: .model)
}
