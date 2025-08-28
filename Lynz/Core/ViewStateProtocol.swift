//
//  ViewStateProtocol.swift
//  Lynz
//
//  Created by Артур Кулик on 28.08.2025.
//

import Foundation
import Combine

protocol ViewStateProtocol: ObservableObject {
    associatedtype State
    associatedtype Intent
    
    var state: State { get }
    func send(_ intent: Intent )
    func reduce(state: inout State, intent: Intent) -> Effect<Intent>
}
