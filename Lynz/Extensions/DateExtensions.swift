//
//  DateExtensions.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import Foundation


/// MARK: - Date Extension
extension Date {
    private static let calendar = Calendar.current
    
    func component(_ component: Calendar.Component) -> Int {
        return Self.calendar.component(component, from: self)
    }
    
    var day: Int {
        component(.day)
    }
    
    var month: Int {
        component(.month)
    }
    
    var year: Int {
        component(.year)
    }
    
    var dayMonthYearDots: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
    
    func monthName(locale: Locale = Locale(identifier: "ru_RU")) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "LLLL"
        return formatter.string(from: self).capitalized
    }
    
    func yearString() -> String {
        String(year)
    }
}


