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
    private(set) var filter1: Dictionary<String, Int> = ["全部": 1, "经济指标": 0, "活动预告": 0, "财经会议": 0, "央行动态": 0]
    private(set) var filter2: Dictionary<String, Int> = ["全部": 1, "新股上市": 0, "新股申购": 0, "休市提醒": 0, "新债上市": 0, "新债申购": 0]
    
    private(set) var filter: Dictionary<String, Int>
    //ScrollView picked first day
    private(set) var selectedDate: Date = Date()
    
    private(set) var stockInfolist: [NewStockInfo]
    
    init(tab: Int = 1, selectedDate: Date = Date()) {
        self.tab = tab
        if tab == 0 {
            self.filter = filter1
        } else {
            self.filter = filter2
        }
        self.selectedDate = selectedDate
        self.stockInfolist = []
        
        var bufferDay = selectedDate
        for _ in 0..<2 {
            let day = bufferDay.getStringID()
            // 1,4
            // 2,5
            // 3
            var stockItems:[[NewStockItem]] = []
            
            //API to request JSON data, according to date
            for data in RequestData{
                if day == data.day {
                    addStock(&stockItems, add: data)
                }
            }
            
            var indexDayStockInfo: NewStockInfo = NewStockInfo(id: bufferDay, possessData: stockItems.count == 0 ? 0 : 1, stockList: stockItems)
            
            stockInfolist.append(indexDayStockInfo)
            
            bufferDay = myCalendar.getNextDay(bufferDay)
        }
    }
    
    mutating func switchTab() {
        if self.tab == 0 {
            self.tab = 1
            self.filter = filter2
        } else {
            self.tab = 0
            self.filter = filter1
        }
    }
    
}

func addStock(_ stockItems: inout [[NewStockItem]], add stock: NewStockItem) {
    if stockItems.count == 0 {
        stockItems.append([stock])
    } else if stockItems.count == 1 {
        let selectedType = stockItems[0][0].stockType
        let currentType = stock.stockType
        if sameTypeStock(selectedType, currentType) {
            stockItems[0].append(stock)
        } else {
            stockItems.append([stock])
        }
    } else if stockItems.count == 2 {
        let selectedType = stockItems[0][0].stockType
        let currentType = stock.stockType
        if sameTypeStock(selectedType, currentType) {
            stockItems[0].append(stock)
        } else {
            stockItems[1].append(stock)
        }
    }
    
    
    func sameTypeStock(_ stockType1: Int,_ stockType2: Int) -> Bool {
        var revisedType1 = 0
        var revisedType2 = 0
        if stockType1 == 2 || stockType1 == 5 {
            revisedType1 = 1
        }
        
        if stockType2 == 2 || stockType2 == 5 {
            revisedType2 = 1
        }
        
        return revisedType1 == revisedType2
    }
}
