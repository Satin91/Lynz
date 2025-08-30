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
    var isToday: Bool {
        let today = Date()
        return day == today.day &&
        date.month == today.month &&
        date.year == today.year
    }
}

// MARK: - Calendar State
struct DatePickerState {
    var currentDate = Date()
    var calendarDays: [CalendarDay] = []
    
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
}

// MARK: - Calendar Store
final class DatePickerViewStore: ViewStore<DatePickerState, DatePickerIntent> {
    
    // MARK: - Configuration
    private let animationDuration: Double = 0.3
    private let calendar = Calendar.current
    
    override func reduce(state: inout DatePickerState, intent: DatePickerIntent) -> Effect<DatePickerIntent> {
        switch intent {
        case .previousMonth:
            if let newDate = calendar.date(byAdding: .month, value: -1, to: state.currentDate) {
                    state.currentDate = newDate
            }
            return .action(.generateCalendar)
            
        case .nextMonth:
            if let newDate = calendar.date(byAdding: .month, value: 1, to: state.currentDate) {
                    state.currentDate = newDate
            }
            return .action(.generateCalendar)
            
        case .selectDay(let calendarDay):
            print("DEBUG: tap day \(calendarDay.day), isCurrentMonth: \(calendarDay.isCurrentMonth)")
            
        case .generateCalendar:
            state.calendarDays = generateDaysInMonth(for: state.currentDate)
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
        
        return days
    }
    
    /// Корректирует день недели для начала с понедельника
    private func adjustWeekdayForMonday(_ weekday: Int) -> Int {
        return weekday == 1 ? 7 : weekday - 1
    }
}

struct DatePickerView: View {
    
    // MARK: - Configuration
    private let itemSize: CGFloat = 46
    private let gridSpacing: CGFloat = 6
    private let maxCalendarGridHeight: CGFloat = 306
    
    enum AnimationDirection {
        case none, left, right
    }
    
    // MARK: - Store
    @StateObject private var store = DatePickerViewStore(initialState: DatePickerState())
    @State var animationDirection: AnimationDirection = .none
    
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
        .onAppear {
            store.send(.generateCalendar)
        }
        .onChange(of: store.state.currentDate) { newValue in
            print("DEBUG: animationDirection \(newValue)")
        }
    }
    
    // MARK: - Weekdays Header
    private var weekdaysHeader: some View {
        HStack(spacing: 6) {
            ForEach(store.state.weekdays, id: \.self) { weekday in
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
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: gridSpacing) {
            ForEach(store.state.calendarDays.indices, id: \.self) { index in
                let calendarDay = store.state.calendarDays[index]
                Text("\(calendarDay.day)")
                    .font(.lzCaption)
                    .foregroundStyle(calendarDay.isCurrentMonth ? .lzWhite : .lzWhite.opacity(0.3))
                    .frame(width: itemSize, height: itemSize)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(calendarDay.isToday ? Color.lzWhite.opacity(0.15) : Color.clear)
                    )
                    .onTapGesture {
                        store.send(.selectDay(calendarDay))
                    }
            }
        }
        .frame(height: maxCalendarGridHeight, alignment: .top)
        .id(store.state.currentDate.month) // id для аниации месяца
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
            makeNavigationButton(systemImage: "chevron.left") {
                animationDirection = .left
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.send(.previousMonth)
                }
            }
            Spacer()
            VStack(spacing: .small) {
                Text(store.state.currentMonth)
                    .font(.lzSectionHeader)
                    .foregroundStyle(.lzWhite)
                    .id(store.state.currentDate.month)
                    .transition(getTransition())
                Text(store.state.currentYear)
                    .font(.lzAccent)
                    .foregroundStyle(.lzWhite.opacity(0.6))
                    .id(store.state.currentDate.year) // id для анимации года
                    .transition(getTransition())
            }
            Spacer()
            makeNavigationButton(systemImage: "chevron.right") {
                animationDirection = .right
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.send(.nextMonth)
                }
            }
        }
    }
    
    private func makeNavigationButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.lzBody)
                .foregroundStyle(.lzWhite)
                .frame(width: 44, height: 44)
                .background(Circle().stroke(.lzWhite, lineWidth: 1))
        }
    }
    
    // MARK: - Helper Methods
}

#Preview {
    CalendarView()
}
