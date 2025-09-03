//
//  Executor.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import Foundation

class Executor {
    private static let dependencyStore = DependencyStore()
    
    public static var perissionInteractor: PermissionInteractor {
        dependencyStore.permissionInteractor
    }
    
    public static var localDataRepository: LocalDataRepository {
        dependencyStore.localDataRepository
    }
    
    public static var localDataInteractor: LocalDataInteractor {
        dependencyStore.localDataInteractor
    }
}
