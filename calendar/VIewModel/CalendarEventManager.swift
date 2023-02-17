//
//  CalendarEventManager.swift
//  calendar
//
//  Created by 王峥 on 2023/2/17.
//

import Foundation

class CalendarEventManager: ObservableObject {
    private static func createCalendarEventManager() -> CalendarEvent {
        CalendarEvent()
    }
    
    @Published private var model = createCalendarEventManager()
    
    var infos: Array<NewStockInfo> {
        model.stockInfolist
    }
}
