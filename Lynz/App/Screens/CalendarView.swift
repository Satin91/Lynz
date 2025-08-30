//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

/// Представляет один день в календарной сетке
struct CalendarDay {
    let day: Int           // Номер дня (1-31)
    let isCurrentMonth: Bool // Принадлежит ли день текущему отображаемому месяцу
    let date: Date         // Полная дата для точных вычислений
}

struct CalendarView: View {
    
    @State private var currentDate = Date()
    @State private var animationDirection: AnimationDirection = .none
    @State private var isMovingForward: Bool? = nil // nil = первый раз, true = вперед, false = назад
    
    // MARK: - Configuration
    private let animationDuration: Double = 0.3
    private let itemSize: CGFloat = 46
    private let gridSpacing: CGFloat = 6
    private let weeksInCalendar = 6
    
    
    
    // MARK: - Constants
    private let calendar = Calendar.current
    private let maxCalendarGridHeight: CGFloat = 306
    
    /// Автоматически получает названия дней недели из текущей локали
    /// Начинает с понедельника (русская традиция)
    private var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        
        var weekdaySymbols = formatter.shortWeekdaySymbols!
        // Перемещаем воскресенье с первой позиции в конец
        weekdaySymbols = Array(weekdaySymbols[1...]) + [weekdaySymbols[0]]
        
        return weekdaySymbols.map { $0.capitalized }
    }
    
    enum AnimationDirection {
        case none, left, right
    }
    
    private var currentMonth: String {
        currentDate.monthName()
    }
    
    private var currentYear: String {
        currentDate.yearString()
    }
    
    private var currentDay: Int {
        Date().day
    }
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            // Дни недели
            weekdaysHeader
                .padding(.bottom, .regularExt)
            // Сетка дней месяца
            calendarGrid
            // Навигация по месяцам
            monthNavigation
        }
        .padding(.horizontal, .mediumExt)
        .background(Color.lzGray.ignoresSafeArea())
    }
    
    // MARK: - Weekdays Header
    private var weekdaysHeader: some View {
        HStack(spacing: 6) {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.lzAccent)
                    .foregroundStyle(.lzWhite.opacity(0.3))
                    .frame(height: itemSize)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, .small)
    }
    
    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        let days = generateDaysInMonth()
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: gridSpacing) {
            ForEach(days.indices, id: \.self) { index in
                let calendarDay = days[index]
                Text("\(calendarDay.day)")
                    .font(.lzCaption)
                    .foregroundStyle(calendarDay.isCurrentMonth ? .lzWhite : .lzWhite.opacity(0.3))
                    .frame(width: itemSize, height: itemSize)
                    .background(
                        Circle()
                            .fill(isToday(calendarDay: calendarDay) ? Color.lzAccent : Color.clear)
                    )
                    .onTapGesture {
                        print("DEBUG: tap day \(calendarDay.day), isCurrentMonth: \(calendarDay.isCurrentMonth)")
                    }
            }
        }
        .frame(height: maxCalendarGridHeight, alignment: .top)
        .id(currentDate.month) // Ключ для анимации
        .transition(getTransition())
    }
    
    private func getTransition() -> AnyTransition {
        switch animationDirection {
        case .left:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .right:
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        case .none:
            return .opacity
        }
    }
    
    // MARK: - Month Navigation
    private var monthNavigation: some View {
        HStack {
            makeNavigationbutton(systemImage: "chevron.left", onTap: previousMonth)
            Spacer()
                         VStack(spacing: .small) {
                 Text(currentMonth)
                     .font(.lzSectionHeader)
                     .foregroundStyle(.lzWhite)
                     .id(currentDate.month) // Ключ для анимации заголовка
                     .transition(getTransition())
                 Text(currentYear)
                     .font(.lzAccent)
                     .foregroundStyle(.lzWhite.opacity(0.6))
                     .id(currentDate.year) // Ключ для анимации года
                     .transition(getTransition())
             }
            Spacer()
            makeNavigationbutton(systemImage: "chevron.right", onTap: nextMonth)
        }
    }
    
    private func makeNavigationbutton(systemImage: String, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.lzBody)
                .foregroundStyle(.lzWhite)
                .frame(width: 44, height: 44)
                .background(Circle().stroke(.lzWhite, lineWidth: 1))
        }
    }
    
    // MARK: - Calendar Generation
    private func generateDaysInMonth() -> [CalendarDay] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate),
              let daysInMonth = calendar.range(of: .day, in: .month, for: currentDate)?.count else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = adjustWeekdayForMonday(firstOfMonth.component(.weekday))
        var days: [CalendarDay] = []
        
        // Дни предыдущего месяца (для заполнения начала недели)
        if firstWeekday > 1 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)?.count ?? 0
            
            for i in 0..<(firstWeekday - 1) {
                let dayNumber = daysInPreviousMonth - (firstWeekday - 2) + i
                if let date = calendar.date(byAdding: .day, value: -(firstWeekday - 1 - i), to: firstOfMonth) {
                    days.append(CalendarDay(day: dayNumber, isCurrentMonth: false, date: date))
                }
            }
        }
        
        // Дни текущего месяца
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(CalendarDay(day: day, isCurrentMonth: true, date: date))
            }
        }
        
        // Дни следующего месяца (для завершения последней недели)
        let remainingDaysInWeek = 7 - (days.count % 7)
        if remainingDaysInWeek < 7 {
            for day in 1...remainingDaysInWeek {
                if let date = calendar.date(byAdding: .day, value: daysInMonth + day - 1, to: firstOfMonth) {
                    days.append(CalendarDay(day: day, isCurrentMonth: false, date: date))
                }
            }
        }
        
        return days
    }
    
    /// Корректирует день недели для начала с понедельника (русская традиция)
    private func adjustWeekdayForMonday(_ weekday: Int) -> Int {
        return weekday == 1 ? 7 : weekday - 1
    }
    
    private func isToday(calendarDay: CalendarDay) -> Bool {
        let today = Date()
        return calendarDay.day == today.day && 
               calendarDay.date.month == today.month && 
               calendarDay.date.year == today.year
    }
    
    // MARK: - Navigation Actions
    private func previousMonth() {
        navigateToMonth(direction: .right, monthOffset: -1, isForward: false)
    }
    
    private func nextMonth() {
        navigateToMonth(direction: .left, monthOffset: 1, isForward: true)
    }
    
    private func navigateToMonth(direction: AnimationDirection, monthOffset: Int, isForward: Bool) {
        animationDirection = direction
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            isMovingForward = isForward
            currentDate = calendar.date(byAdding: .month, value: monthOffset, to: currentDate) ?? currentDate
        }
    }
}

#Preview {
    CalendarView()
}

// MARK: - Date Extension
//// MARK: - Date Extension
//extension Date {
//    private static let calendar = Calendar.current
//    
//    func component(_ component: Calendar.Component) -> Int {
//        return Self.calendar.component(component, from: self)
//    }
//    
//    var day: Int {
//        component(.day)
//    }
//    
//    var month: Int {
//        component(.month)
//    }
//    
//    var year: Int {
//        component(.year)
//    }
//    
//    func monthName(locale: Locale = Locale(identifier: "ru_RU")) -> String {
//        let formatter = DateFormatter()
//        formatter.locale = locale
//        formatter.dateFormat = "LLLL"
//        return formatter.string(from: self).capitalized
//    }
//    
//    func yearString() -> String {
//        String(year)
//    }
//}
