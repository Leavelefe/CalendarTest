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
}
