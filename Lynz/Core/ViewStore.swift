//
//  ViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import Foundation
import Combine

class ViewStoreBase: ObservableObject {
    @Published var coorinator: Coordinator = Coordinator()
    @Published var executor = Executor()
}

class ViewStore<State, Intent>: ViewStateProtocol {
    @Published private(set) var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    init(initialState: State) {
        self.state = initialState
    }
    
    @MainActor
    public final func send(_ intent: Intent) {
        var newState = state
        let effect = reduce(state: &newState, intent: intent)
        updateState(newState)
        handleEffect(effect)
    }
    
    /// Overriden reduce method
    public func reduce(state: inout State, intent: Intent) -> Effect<Intent> {
        return .none
    }
    
    // Приватный метод для обновления состояния
    private func updateState(_ newState: State) {
        self.state = newState
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

//MARK: - Handle Effect
extension ViewStore {
    // Приватный метод для обработки эффектов
    @MainActor
    private func handleEffect(_ effect: Effect<Intent>) {
        switch effect {
        case .intent(let intent):
            Task { @MainActor in
                send(intent)
            }
            
        case .asyncTask(let task):
            Task { @MainActor in
                let resultEffect = await task()
                handleEffect(resultEffect)
            }
            
        case .closure(let actionClosure):
            let action = actionClosure()
            send(action)
            
        case .publisher(let publisher):
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: send(_:))
                .store(in: &cancellables)
            
        case .sequence(let actions):
            Task { @MainActor in
                for action in actions {
                    send(action)
                    try? await Task.sleep(nanoseconds: 50_000_000)
                }
            }
            
        case .parallel(let actions):
            Task { @MainActor in
                await withTaskGroup(of: Void.self) { group in
                    for action in actions {
                        group.addTask { @MainActor [weak self] in
                            self?.send(action)
                        }
                    }
                }
            }
            
        case .delayed(let action, let delay):
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                send(action)
            }
            
        case .navigate(let navAction):
            switch navAction {
            case .push(let screen):
                coordinator.push(page: screen)
            case .fullScreenCover(let screen):
                coordinator.fullScreenCover(page: screen)
            case .popToRoot:
                coordinator.popToRoot()
            case .pop:
                coordinator.pop()
            }
        case .none:
            break
        }
    }
}

//MARK: - Navigation
extension ViewStore: Navigation { }
