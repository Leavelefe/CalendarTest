//
//  CalendarManageViewModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/7.
//

import Foundation
/// Under Construction

class CalendarManageViewModel: ObservableObject {
    static let weekDays =  ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    static func createCalendar() -> CalendarModel {
        CalendarModel()
    }
    
    @Published private var model: CalendarModel = createCalendar()
    
    var days: Array<DayModel> {
        model.daySet_Series
    }
    
    func choose(_ day: DayModel) {
        model.choose(day)
    }
    
}
