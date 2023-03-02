//
//  SystemCalendar.swift
//  calendar
//
//  Created by 王峥 on 2023/2/9.
//

import Foundation

/// myCalendar is  a singleton among the program
/// It define the calender system we need in format
/// Povides caculation functions for days counting
let myCalendar = SystemCalendar()


struct SystemCalendar {
    public var calendar: Calendar = Calendar(identifier: .gregorian)
    init() {
        //Monday should be the first day in a week
        calendar.firstWeekday = 2
    }
    
    
    /// generateDays
    /// - Parameters:
    ///   - interval: Interval for caculating days
    ///   - components: DateComponents required for matching
    /// - Returns: Return an array of dates
    func generateDays (inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        
        var dates: [Date] = []
        dates.append(interval.start)
        
        calendar.enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            
            if let date {
                if date < interval.end {
                    dates.append(date)
                    
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
    
    
    /// monthDays
    /// - Parameter oneDay: One day in a month
    /// - Returns: Return an array of dates in that month
    public func monthDays(oneDay: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: oneDay),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else { return [] }
        
        
        return self.generateDays( inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end), matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    
    /// weekDays
    /// - Parameter oneDay: One day in a week
    /// - Returns: Return an array of dates in that week
    public func weekDays(oneDay: Date) -> [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: oneDay)
        else { return [] }
        
        let days = self.generateDays( inside: DateInterval(start: weekInterval.start, end: weekInterval.end), matching: DateComponents(hour: 0, minute: 0, second: 0))
        return days
    }
    
    
    /// isCurrentMonth
    /// - Parameters:
    ///   - day_1: The first comparator
    ///   - day_2: The second comparator
    /// - Returns: Whether these two days are in the same month
    public func isCurrentMonth(is day_1: Date, equalto day_2: Date) -> Bool {
        calendar.isDate(day_1, equalTo: day_2, toGranularity: .month)
    }
    
    /// isCurrentMonth
    /// - Parameters:
    ///   - day_1: The first comparator
    ///   - day_2: The second comparator
    /// - Returns: Whether these two days are same
    public func isSameDay(is day_1: Date, equalto day_2: Date) -> Bool {
        calendar.isDate(day_1, inSameDayAs: day_2)
    }
    
    
    /// adjacentThreeMonths
    /// - Parameter oneDay: Selected Date
    /// - Returns: adjacent Three Month based on selected date
    public func adjacentThreeMonths(oneDay: Date) -> [Date] {
        //logic need to be adjust for 13 and 0 case
        var dates: [Date] = []
        
        var previousMonth = DateComponents()
            previousMonth.day = 1
            previousMonth.month = oneDay.get(.month) - 1
            previousMonth.year = oneDay.get(.year)
        
        var nextMonth = DateComponents()
            nextMonth.day = 1
            nextMonth.month = oneDay.get(.month) + 1
            nextMonth.year = oneDay.get(.year)
        
        
        guard let previous = calendar.date(from: previousMonth),
              let next = calendar.date(from: nextMonth)
        else { return []}
        dates.append(previous)
        dates.append(oneDay)
        dates.append(next)
        return dates
    }
    
    
    /// getPreviousDay
    /// - Parameter nowDay: Selected Date
    /// - Returns: The day before selected date
    private func getPreviousDay(_ nowDay: Date) -> Date {
        
        let lastTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
//        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        
        let lastDate = nowDay.addingTimeInterval(lastTime)
        return lastDate
    }
    
    
    /// getNextDay
    /// - Parameter nowDay: Selected Date
    /// - Returns: The day after selected date
    public func getNextDay(_ nowDay: Date) -> Date {
        let nextTime: TimeInterval = 24*60*60 //
        
        let nextDate = nowDay.addingTimeInterval(nextTime)
        return nextDate
    }
    
    
    /// startOfCurrentMonth
    /// - Parameter nowDay: Selected Date
    /// - Returns: The first day of the month to which the selected date belongs
    private func startOfCurrentMonth(_ nowDay: Date) -> Date {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: nowDay)
        let startOfMonth = calendar.date(from: components)
        
        return startOfMonth!
    }
    
    /// endOfCurrentMonth
    /// - Parameter nowDay: Selected Date
    /// - Returns: The last day of the month to which the selected date belongs
    private func endOfCurrentMonth(_ nowDay: Date) -> Date {
        
        let calendar = Calendar.current
        var components = DateComponents()
            components.month = 1
            components.second = -1
            //components.day = -1
        //startOfCurrentMonth
        let currentMonth = calendar.dateComponents([.year, .month], from: nowDay)
        let startOfMonth = calendar.date(from: currentMonth)
        let endOfMonth = calendar.date(byAdding: components, to: startOfMonth!)
        
        return endOfMonth!
    }
    
    /// nextMonth
    /// - Parameter nowDay: Selected Date
    /// - Returns: The first day of the next month to which the selected date belongs
    public func nextMonth(_ nowDay: Date) -> Date {
        let endOfCurrentMonth: Date = self.endOfCurrentMonth(nowDay)
        let nextMonthFirstDate: Date = self.getNextDay(endOfCurrentMonth)
        
        return nextMonthFirstDate
    }
    
    /// previousMonth
    /// - Parameter nowDay: Selected Date
    /// - Returns: The last day of the last month to which the selected date belongs
    public func previousMonth(_ nowDay: Date) -> Date {
        let startOfCurrentMonth: Date = self.startOfCurrentMonth(nowDay)
        let previousMonthLastDate: Date = self.getPreviousDay(startOfCurrentMonth)
        
        return previousMonthLastDate
    }
    
    /// nextWeek
    /// - Parameter nowDay: Selected Date
    /// - Returns: The first day of the next week to which the selected date belongs
    public func nextWeek(_ nowDay: Date) -> Date {
        let endOfCurrentWeek: Date = self.weekDays(oneDay: nowDay).last!
        let nextWeekFirstDate: Date = self.getNextDay(endOfCurrentWeek)
        
        return nextWeekFirstDate
    }
    
    /// previousWeek
    /// - Parameter nowDay: Selected Date
    /// - Returns: The last day of the last week to which the selected date belongs
    public func previousWeek(_ nowDay: Date) -> Date {
        let startOfCurrentWeek: Date = self.weekDays(oneDay: nowDay).first!
        let previousWeekLastDate: Date = self.getPreviousDay(startOfCurrentWeek)
        
        return previousWeekLastDate
    }
//    public var adjacentThreeWeeks(oneDay: Date) -> [Date] {
//        calendar.generateDates( inside: interval,matching: DateComponents(hour: 0, minute: 0, second:0, weekday: 2) )
//    }
        
}
