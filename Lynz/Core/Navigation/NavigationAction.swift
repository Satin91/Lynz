//
//  NavigationAction.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation

enum NavigationCases {
    case push(_ screen: Page)
    case fullScreenCover(_ screen: Page)
    case popToRoot
    case pop
}
