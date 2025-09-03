//
//  TestEnvironment.swift
//  Lynz
//
//  Created by Артур Кулик on 31.08.2025.
//

import Foundation

/// Полезная штука для процесса разработки, например для вёрстки, проверки запросов, поведения ui
final class TestEnvironment {
    
#if DEBUG
    private static var developerMode: Bool = false
#else
    private static var developerMode: Bool = false
#endif
    
    static func forcePage(test: Page, original: Page) -> Page {
        guard developerMode else { return original }
        return test
    }
    
    static func emulateAsynTask(duration: Double) async {
        guard developerMode else { return }
        try! await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
}
