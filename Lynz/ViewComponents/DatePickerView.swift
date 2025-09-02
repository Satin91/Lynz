//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

/// Представляет один день в календарной сетке
struct CalendarDay: Identifiable {
    var id = UUID()
    let day: Int           // Номер дня (1-31)
    let isCurrentMonth: Bool // Принадлежит ли день текущему отображаемому месяцу
    let date: Date         // Полная дата для точных вычислений
    var plan: Plan? // Добавляем массив событий
    
    var isToday: Bool {
        let today = Date()
        return day == today.day &&
        date.month == today.month &&
        date.year == today.year
    }
    
    // Добавляем вычисляемое свойство для проверки наличия событий
    var hasEvent: Bool {
//        !plan.isEmpty
        plan != nil
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

struct DatePickerView: View {
    
    var onTapDay: ((CalendarDay) -> Void)?
    private let plans: [Plan]
    
    // MARK: - Configuration
    private let itemSize: CGFloat = 46
    private let gridSpacing: CGFloat = 6
    private let maxCalendarGridHeight: CGFloat = 306
    
    private var calendarItems: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: 7)
    }
    
    enum AnimationDirection {
        case none, left, right
    }
    @State var animationDirection: AnimationDirection = .none
    
    // MARK: - Store
    @StateObject private var store: DatePickerViewStore
    
    
    init(plans: [Plan], onTapDay: ((CalendarDay) -> Void)? = nil) {
        self.onTapDay = onTapDay
        self.plans = plans
        _store = StateObject(wrappedValue: DatePickerViewStore(initialState: .init(plans: plans)))
    }
    
        var body: some View {
        content
            .onAppear {
                store.send(.generateCalendar)
            }
            .onChange(of: plans) { newPlans in
                store.send(.updatePlans(newPlans))
            }
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            weekdaysHeader
            calendarGrid
            monthNavigation
        }
        .padding(.horizontal, .mediumExt)

    }
    
    // MARK: - Weekdays Header
    private var weekdaysHeader: some View {
        HStack(spacing: 6) {
            ForEach(store.state.weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.lzAccent)
                    .foregroundStyle(.lzWhite.opacity(0.3))
                    .frame(height: itemSize)
                    .frame(maxWidth: itemSize)
            }
        }
        .padding(.horizontal, .small)
    }
    
    private var calendarGrid: some View {
        List { // Обернул в List чтобы для Lazy Grid правильно заработала анимация
            LazyVGrid(columns: calendarItems, spacing: gridSpacing) {
                ForEach(store.state.calendarDays.indices, id: \.self) { index in
                    let calendarDay = store.state.calendarDays[index]
                    
                    VStack(spacing: 2) {
                        Text("\(calendarDay.day)")
                            .font(.lzCaption)
                            .foregroundStyle(calendarDay.isCurrentMonth ? .lzWhite : .lzWhite.opacity(0.3))
                    }
                    .frame(width: itemSize, height: itemSize)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(calendarDay.isToday ? Color.lzWhite.opacity(0.15) : Color.clear)
                            // Индикатор событий
                            if let plan = calendarDay.plan {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(plan.role.tint, lineWidth: 1)
                                    .padding(1)
                            }
                        }
                    )
                    .onTapGesture {
                        onTapDay?(calendarDay)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
        }
        .frame(height: maxCalendarGridHeight, alignment: .top)
        .listStyle(.plain)
        .scrollDisabled(true)
        .padding(.zero)
        .transition(getTransition())
        .id(store.state.currentDate.month)
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
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity))
        }
    }
    
    // MARK: - Month Navigation
    private var monthNavigation: some View {
        HStack {
            
//            makeNavigationButton(systemImage: "chevron.left") {
            MainCircleButton(color: .lzYellow, image: .chevronLeft) {
                // Устанавливаем направление ДО анимации
                animationDirection = .right  // Предыдущий месяц - движение вправо
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.send(.previousMonth)
                }
                
                // Сбрасываем направление после анимации
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    animationDirection = .none
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
                    .id(store.state.currentDate.year)
                    .transition(getTransition())
            }
            Spacer()
            
            MainCircleButton(color: .lzYellow, image: .chevronRight) {
//            makeNavigationButton(systemImage: "chevron.right") {
                // Устанавливаем направление ДО анимации
                animationDirection = .left  // Следующий месяц - движение влево
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.send(.nextMonth)
                }
                
                // Сбрасываем направление после анимации
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    animationDirection = .none
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
    DatePickerView(plans: [])
        .background(Color.gray)
}
