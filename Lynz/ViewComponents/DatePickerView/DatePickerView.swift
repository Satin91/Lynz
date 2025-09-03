//
//  CalendarView.swift
//  Lynz
//
//  Created by Артур Кулик on 30.08.2025.
//

import SwiftUI

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
    
    @StateObject private var store: DatePickerViewStore
    @State var animationDirection: AnimationDirection = .none
    
    // MARK: - Store
    
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
            MainCircleButton(color: .lzYellow, image: .chevronLeft) {
                // Устанавливаем направление ДО анимации
                animationDirection = .right
                
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
                animationDirection = .left
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    store.send(.nextMonth)
                }
                
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
