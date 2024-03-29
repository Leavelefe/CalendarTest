//
//  CalendarEventManager.swift
//  calendar
//
//  Created by 王峥 on 2023/2/17.
//

import Foundation


/// ScrollView中管理日历事件的viewModel，遵循CalendarManagerDelegate协议
/// 当CalendarManageViewModel点击实际触发时，代理执行事件切换
class CalendarEventManager: ObservableObject, CalendarManagerDelegate {
    lazy var firstViewModel: CalendarManageViewModel = {
        let viewModel = CalendarManageViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    /// Protocol
    func CalendarManagerDidUpdateLocatedDate(_ viewModel: CalendarManageViewModel, locatedDate: Date) {
        if model.selectedDate != locatedDate {
            model.changeSelectedDate(locatedDate)
        }
    }
    
    
    private static func createCalendarEventManager() -> CalendarEvent {
        CalendarEvent()
    }
    
    @Published private var model = createCalendarEventManager()
    
    var stockInfos: Array<NewStockInfo> {
        model.stockInfolist
    }
    
    var ecoInfos: Array<NewEcoInfo> {
        model.ecoInfolist
    }
    
    var showEco: Bool {
        model.tab == 0 ? true : false
    }
    
    var filterContent: [(title: String, selected: Bool)] {
        model.filter
    }
    
    func switchTab(_ selectedIndex: Int) {
        model.switchTab(selectedIndex)
    }
    
    func changeFilter(action cancelOrSelect: Bool, selectedTitle title: String) {
        //true: Set title to true
        //false: Set title to false
        model.changeFilter(cancelOrSelect, title)
    }
}
