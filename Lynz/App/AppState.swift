//
//  AppState.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()
    
    private init() { }
    
    @Published private(set) var isShowLoader: Bool = false
    
    func showLoader() {
        isShowLoader = true
    }
    
    func hideLoader() {
        isShowLoader = false
    }
}
