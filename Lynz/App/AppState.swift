//
//  AppState.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var navBarColor: Color = .white
    private init() { }
    
    @Published private(set) var isShowLoader: Bool = false
    
    func showLoader() {
        isShowLoader = true
    }
    
    func hideLoader() {
        isShowLoader = false
    }
    
    func setNavvigationBarColor(_ color: Color) {
        navBarColor = color
    }
}
