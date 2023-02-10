//
//  CalendarModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/8.
//

import Foundation

/// Under Construction
struct CalendarModel {
    private(set) var today: Date = Date()
    private(set) var Mode: ModeType = .Month
    private(set) var locatedDay: Date?
    
    /// 1 - Monday 2-Tueday ......
    private(set) var locatedIndex: Int?
    
    
    //Mark: Store structure under construction
    private(set) var daySet_Series: Array<DayModel>
//    private(set) var daySet_Series2: Array<DayModel>
//    private(set) var daySet_Series3: Array<DayModel>
    
    /// <#Description#>
    init() {
        daySet_Series = Array<DayModel>()
        locatedDay = today
        locatedIndex = getLocatedIndex(date: today)
        let daySet = myCalendar.monthDays(oneDay: today)
        
        //Mark: daySet_Series Detial need be filled later
        for index in 0..<daySet.count {
            var isCurrentMonth: Bool = myCalendar.isCurrentMonth(is: daySet[index], equalto: locatedDay!)
            daySet_Series.append(DayModel(id: index, isCurrentMonth: isCurrentMonth, date: daySet[index]))
        }
                    
    }
    
    private func getLocatedIndex(date: Date) -> Int {
        date.get(.weekday) <= 1 ? 7 - date.get(.weekday) : date.get(.weekday) - 1
    }
    
    mutating func choose(_ day: DayModel) {
        if let chooseIndex = daySet_Series.firstIndex(where: {$0.id == day.id}),
            daySet_Series[chooseIndex].isCurrentMonth
        {
            if let defaultPickedDate = locatedIndex {
                daySet_Series[defaultPickedDate].picked = false
                locatedIndex = chooseIndex
                daySet_Series[chooseIndex].picked.toggle()
            } else {
                locatedIndex = chooseIndex
                daySet_Series[chooseIndex].picked.toggle()
            }
        }
    }
}

enum ModeType{
    case Month
    case Week
}
