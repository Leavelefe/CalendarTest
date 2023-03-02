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
    
    
    /// getStringID
    /// - Returns: 得到该日期“yyyyMMdd”的形式
    func getStringID() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self)
    }
    
    /// getStringID
    /// - Returns: 得到该日期“yyyy年MM月”的形式
    func getStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: self)
    }
    
    /// getFullStringDate
    /// - Returns: 得到该日期“yyyy年MM月dd日 HH:mm”的形式
    func getFullStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter.string(from: self)
    }
    
    /// getHourAndMinutes
    /// - Returns: 得到该日期的具体时间以“HH:mm”的形式
    func getHourAndMinutes() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    /// getWeekDay
    /// - Returns: 得到该日期的所属具体weekday
    func getWeekDay() -> String {
        let weekday = self.get(.weekday)
        let weekList = ["星期日","星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        return weekList[weekday - 1]
    }
}
