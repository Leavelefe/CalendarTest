//
//  Date+formart.swift
//  calendar
//
//  Created by 王峥 on 2023/2/9.
//

import Foundation

extension Date {
    
    /// get
    /// - Parameters:
    ///   - components: month, year, day ..
    ///   - calendar: calendar we choose
    /// - Returns: return month, year, day .. we have selected
    func get(_ components: Calendar.Component..., calendar: Calendar = myCalendar.calendar) -> DateComponents {
            return calendar.dateComponents(Set(components), from: self)
        }

    func get(_ component: Calendar.Component, calendar: Calendar = myCalendar.calendar) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getStringID() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self)
    }
    
    func getStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: self)
    }
    
    func getWeekDay() -> String {
        let weekday = self.get(.weekday)
        if weekday == 1 {
            return "星期日"
        } else if weekday == 2 {
            return "星期一"
        } else if weekday == 3 {
            return "星期二"
        } else if weekday == 4 {
            return "星期三"
        } else if weekday == 5 {
            return "星期四"
        } else if weekday == 6 {
            return "星期五"
        } else {
            return "星期六"
        }
    }
}
