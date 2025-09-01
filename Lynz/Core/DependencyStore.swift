//
//  DependencyStore.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import Foundation

class DependencyStore {
    lazy var attService = ATTService()
    lazy var coreDataService = CoreDataService.shared
    lazy var localDataRepository = LocalDataRepository(coreDataService: coreDataService)
    lazy var localDataInteractor = LocalDataInteractor(repository: localDataRepository)
}
