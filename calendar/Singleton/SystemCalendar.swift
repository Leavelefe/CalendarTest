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


struct SystemCalendar{
    public var calendar: Calendar = Calendar(identifier: .gregorian)
    init() {
        //Monday should be the first day in a week
        calendar.firstWeekday = 3
    }
    
    
    /// generateDays
    /// - Parameters:
    ///   - interval: Interval for caculating days
    ///   - components: DateComponents required for matching
    /// - Returns: Return an array of dates
    func generateDays(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        
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
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
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
    
//    public var adjacentThreeWeeks(oneDay: Date) -> [Date] {
//        calendar.generateDates( inside: interval,matching: DateComponents(hour: 0, minute: 0, second:0, weekday: 2) )
//    }
        
}
