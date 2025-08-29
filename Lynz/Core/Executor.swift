//
//  Executor.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import Foundation

class Executor {
    private static let dependencyStore = DependencyStore()
    
    public static var attService: ATTService {
        dependencyStore.attService
    }
}
