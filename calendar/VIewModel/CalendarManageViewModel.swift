//
//  CalendarManageViewModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/7.
//

import Foundation
/// Under Construction


/// 选择指定日期后的代理
protocol CalendarManagerDelegate: AnyObject {
    func CalendarManagerDidUpdateLocatedDate(_ viewModel: CalendarManageViewModel, locatedDate: Date)
}


/// 用于控制顶部日历各种切换的ViewModel
class CalendarManageViewModel: ObservableObject {
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
    
    var weekDays: [Weekday] {
        ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    }
    
    var TopTextDate: String {
        model.locatedDay.getStringDate()
    }
    
    var mode: ModeType {
        model.mode
    }
    
    func previousOrNextDays(isPreious: Bool) -> Array<DayModel> {
        model.returnPreviousOrNextDays(isPrevios: isPreious)
    }
    
    func choose(_ day: DayModel) {
        model.choose(day)
    }
    
    func swithMode(_ mode: ModeType) {
        model.swithMode(mode)
    }
    
    func swipeMonthOrWeek(_ isLeft: Bool) {
        model.changeMonthOrWeek(!isLeft)
    }
    
    func BackToToday() {
        model.BackToToday()
    }
    
    var daySeriesLengthNotEqual: Bool {
        model.lengthNotEqual
    }
    
}
