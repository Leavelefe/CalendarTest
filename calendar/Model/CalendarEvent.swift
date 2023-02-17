//
//  CalendarEvent.swift
//  calendar
//
//  Created by 王峥 on 2023/2/17.
//

import Foundation

struct CalendarEvent {
    //0 - 宏观财经
    //1 - 股票理财
    private(set) var tab: Int = 1
    // 0 - all
    // 1 - 经济指标/新股上市
    // 2 - 活动预告/新股申购
    // 3 - 财经会议/休市提醒
    // 4 - 央行动态/新债上市
    // 5 - (none)/新债申购
    private(set) var filter: [Int]
    //ScrollView picked first day
    private(set) var selectedDate: Date = Date()
    
    private(set) var stockInfolist: [NewStockInfo]
    
    init(tab: Int = 1, filter: [Int] = [0], selectedDate: Date = Date()) {
        self.tab = tab
        self.filter = filter
        self.selectedDate = selectedDate
        self.stockInfolist = []
        
        var bufferDay = selectedDate
        for _ in 0..<2 {
            let day = bufferDay.getStringID()
            var stockItems:[NewStockItem] = []
            
            //API to request JSON data, according to date
            for data in RequestData{
                if day == data.day {
                    stockItems.append(data)
                }
            }
            
            var indexDayStockInfo: NewStockInfo = NewStockInfo(id: bufferDay, possessData: stockItems.count == 0 ? 0 : 1, stockList: stockItems)
            
            stockInfolist.append(indexDayStockInfo)
            
            bufferDay = myCalendar.getNextDay(bufferDay)
        }
    }
}
