//
//  ResignFirstResponder.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import UIKit

func resignFirstResponder() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
