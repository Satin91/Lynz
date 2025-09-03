//
//  DatePickerViewStore.swift
//  Lynz
//
//  Created by Артур Кулик on 03.09.2025.
//

import Foundation

// Представляет один день в календарной сетке
struct CalendarDay: Identifiable {
    var id = UUID()
    let day: Int
    let isCurrentMonth: Bool
    let date: Date
    var plan: Plan?
    
    var isToday: Bool {
        let today = Date()
        return day == today.day &&
        date.month == today.month &&
        date.year == today.year
    }
    
    static var stub = CalendarDay(day: 1, isCurrentMonth: true, date: Date(), plan: nil)
}

// MARK: - Calendar State
struct DatePickerState {
    var currentDate = Date()
    var calendarDays: [CalendarDay] = []
    var plans: [Plan] // Добавляем массив событий
    
    // MARK: - Computed Properties
    var currentMonth: String {
        currentDate.monthName()
    }
    
    var currentYear: String {
        currentDate.yearString()
    }
    
    var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        
        var weekdaySymbols = formatter.shortWeekdaySymbols!
        // Перемещаем воскресенье с первой позиции в конец
        weekdaySymbols = Array(weekdaySymbols[1...]) + [weekdaySymbols[0]]
        
        return weekdaySymbols.map { $0.capitalized }
    }
}

// MARK: - Calendar Intent
enum DatePickerIntent {
    case previousMonth
    case nextMonth
    case selectDay(CalendarDay)
    case generateCalendar
    case updatePlans([Plan])
}

// MARK: - Calendar Store
final class DatePickerViewStore: ViewStore<DatePickerState, DatePickerIntent> {
    
    private let calendar = Calendar.current
    
    override func reduce(state: inout DatePickerState, intent: DatePickerIntent) -> Effect<DatePickerIntent> {
        switch intent {
        case .previousMonth:
            if let newDate = calendar.date(byAdding: .month, value: -1, to: state.currentDate) {
                state.currentDate = newDate
            }
            return .intent(.generateCalendar)
            
        case .nextMonth:
            if let newDate = calendar.date(byAdding: .month, value: 1, to: state.currentDate) {
                state.currentDate = newDate
            }
            return .intent(.generateCalendar)
            
        case .selectDay(let calendarDay):
            print("DEBUG: tap day \(calendarDay.day), isCurrentMonth: \(calendarDay.isCurrentMonth)")
            
        case .generateCalendar:
            state.calendarDays = generateDaysInMonth(for: state.currentDate)
            
        case .updatePlans(let newPlans):
            state.plans = newPlans
            return .intent(.generateCalendar)
        }
        
        return .none
    }
    
    // MARK: - Calendar Generation
    private func generateDaysInMonth(for date: Date) -> [CalendarDay] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let daysInMonth = calendar.range(of: .day, in: .month, for: date)?.count else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = adjustWeekdayForMonday(firstOfMonth.component(.weekday))
        var days: [CalendarDay] = []
        
        // Дни предыдущего месяца (для заполнения начала недели)
        if firstWeekday > 1 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: date) ?? date
            let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)?.count ?? 0
            
            for i in 0..<(firstWeekday - 1) {
                let dayNumber = daysInPreviousMonth - (firstWeekday - 2) + i
                if let dayDate = calendar.date(byAdding: .day, value: -(firstWeekday - 1 - i), to: firstOfMonth) {
                    days.append(CalendarDay(day: dayNumber, isCurrentMonth: false, date: dayDate))
                }
            }
        }
        
        // Дни текущего месяца
        for day in 1...daysInMonth {
            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(CalendarDay(day: day, isCurrentMonth: true, date: dayDate))
            }
        }
        
        // Дни следующего месяца (для завершения последней недели)
        let remainingDaysInWeek = 7 - (days.count % 7)
        if remainingDaysInWeek < 7 {
            for day in 1...remainingDaysInWeek {
                if let dayDate = calendar.date(byAdding: .day, value: daysInMonth + day - 1, to: firstOfMonth) {
                    days.append(CalendarDay(day: day, isCurrentMonth: false, date: dayDate))
                }
            }
        }
        
        // После создания всех дней, сопоставляем события
        for i in 0..<days.count {
            let dayDate = days[i].date
            
            let eventsForDay = state.plans.filter { plan in
                calendar.isDate(plan.date, inSameDayAs: dayDate)
            }
            if let eventForDay = eventsForDay.first {
                days[i].plan = eventForDay
            }
        }
        
        return days
    }
    
    /// Корректирует день недели для начала с понедельника
    private func adjustWeekdayForMonday(_ weekday: Int) -> Int {
        return weekday == 1 ? 7 : weekday - 1
    }
}
