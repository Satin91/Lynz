//
//  DependencyStore.swift
//  Lynz
//
//  Created by Артур Кулик on 29.08.2025.
//

import Foundation
import CoreData

@MainActor
class DependencyStore {
    lazy var attService = ATTService()
    lazy var coreDataService = CoreDataService()
    lazy var entityMapper = EntityMapper(coreDataService: coreDataService)
    lazy var dataRepository = DataRepository(coreDataService: coreDataService, entityMapper: entityMapper)
    lazy var localDataInteractor = LocalDataInteractor(repository: dataRepository)
}
