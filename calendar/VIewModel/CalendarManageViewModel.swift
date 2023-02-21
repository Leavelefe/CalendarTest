//
//  CalendarManageViewModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/7.
//

import Foundation
/// Under Construction

protocol CalendarManagerDelegate: AnyObject {
    func CalendarManagerDidUpdateLocatedDate(_ viewModel: CalendarManageViewModel, locatedDate: Date)
}

class CalendarManageViewModel: ObservableObject {
    static let weekDays =  ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    weak var delegate: CalendarManagerDelegate?
    
    private static func createCalendar() -> CalendarModel {
        CalendarModel()
    }
    
    @Published private var model = createCalendar() {
        didSet {
            delegate?.CalendarManagerDidUpdateLocatedDate(self, locatedDate: model.locatedDay)
        }
    }
    
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
