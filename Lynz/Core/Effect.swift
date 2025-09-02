//
//  Effect.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import Foundation
import Combine

enum Effect<Intent>: ExpressibleByNilLiteral {
    init(nilLiteral: ()) {
        self = .none
    }
    
    case none
    case action(Intent)
    case closure(() -> Intent)
    case asyncTask(() async -> Effect<Intent>)
    case publisher(AnyPublisher<Intent, Never>)
    case sequence(_ actions: [Intent])
    case parallel(_ actions: [Intent])
    case delayed(_ action: Intent, delay: Double)
    case push(_ screen: Page)
}

extension Effect: CaseIterable where Intent: CaseIterable {
    static var allCases: [Effect<Intent>] {
        var cases: [Effect<Intent>] = [.none]
        
        // Кейсы с Intent - перебираем все варианты Action
        cases += Intent.allCases.map { Effect.action($0) }
        cases += Intent.allCases.map { Effect.sequence([$0]) }
        cases += Intent.allCases.map { Effect.parallel([$0]) }
        
        return cases
    }
}

extension Effect: Sequence {
    func makeIterator() -> AnyIterator<Intent> {
        switch self {
        case .none:
            return AnyIterator { nil }
        case .action(let action):
            return AnyIterator(CollectionOfOne(action).makeIterator())
        case .asyncTask:
            return AnyIterator { nil } // Асинхронные задачи обрабатываются отдельно
        case .publisher:
            return AnyIterator { nil } // Publisher'ы обрабатываются отдельно
        case .sequence(let actions):
            return AnyIterator(actions.makeIterator())
        case .parallel(let actions):
            return AnyIterator(actions.makeIterator())
        case .delayed(let action, _):
            return AnyIterator(CollectionOfOne(action).makeIterator())
        case .closure(let actionClosure):
            return AnyIterator(CollectionOfOne(actionClosure()).makeIterator())
        case .push(let screen):
            return AnyIterator { nil }
        }
    }
}
