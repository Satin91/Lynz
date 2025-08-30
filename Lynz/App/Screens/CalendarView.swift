//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    
    private let calendar = Calendar.current
    private let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    private let maxCalendarGridHeight: CGFloat = 306 // (6 weeks * 46px) + ( )
    
    
    // MARK: - Computed Properties
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
//                .padding(.bottom, .regularExt)
            // Сетка дней месяца
            calendarGrid
//                .padding(.bottom, .large)
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
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, .small)
    }
    
    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        let days = generateDaysInMonth()
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
            ForEach(days, id: \.self) { day in
                if day == 0 {
                    // Пустая ячейка для дней предыдущего месяца
                    Text("")
                        .frame(width: 46, height: 46)
                } else {
                    Text("\(day)")
                        .font(.lzCaption)
                        .foregroundStyle(.lzWhite)
                        .frame(width: 46, height: 46)
                        .background(
                            Circle()
                                .fill(isToday(day: day) ? Color.lzAccent : Color.clear)
                        )
                        .onTapGesture {
                            print("DEBUG: tap day \(day)")
                        }
                }
            }
        }
        .frame(height: maxCalendarGridHeight, alignment: .top)
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
                 Text(currentYear)
                     .font(.lzAccent)
                     .foregroundStyle(.lzWhite.opacity(0.6))
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
    
    // MARK: - Helper Methods
    private func generateDaysInMonth() -> [Int] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = firstOfMonth.component(.weekday)
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentDate)?.count ?? 0
        
        // Корректируем для понедельника как первого дня недели
        let adjustedFirstWeekday = firstWeekday == 1 ? 7 : firstWeekday - 1
        
        var days: [Int] = []
        
        // Добавляем пустые дни в начале
        for _ in 1..<adjustedFirstWeekday {
            days.append(0)
        }
        
        // Добавляем дни месяца
        for day in 1...numberOfDaysInMonth {
            days.append(day)
        }
        
        return days
    }
    
    private func isToday(day: Int) -> Bool {
        let today = Date()
        return day == today.day && 
               currentDate.month == today.month && 
               currentDate.year == today.year
    }
    
    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }
    
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }
}

#Preview {
    CalendarView()
}
