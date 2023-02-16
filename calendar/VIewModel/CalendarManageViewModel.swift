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
    
    private static func createCalendar() -> CalendarModel {
        CalendarModel()
    }
    
    @Published private var model = createCalendar()
    
    var days: Array<DayModel> {
        model.daySet_Series
    }
    
    var TopTextDate: String {
        model.locatedDay.getStringDate()
    }
    
    var mode: ModeType {
        model.mode
    }
    
    func choose(_ day: DayModel) {
        model.choose(day)
    }
    
    func swithMode(_ mode: ModeType) {
        model.swithMode(mode)
    }
    
    func swipeMonthOrWeek(_ direction: SwipeGesture.Direction) {
        model.changeMonthOrWeek(direction)
    }
    
    func BackToToday() {
        model.BackToToday()
    }
    
}
