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
    private(set) var filter1: [(title: String, selected: Bool)] = [(title: "全部", selected: true), (title: "经济指标", selected: false), (title: "活动预告", selected: false), (title: "财经会议", selected: false), (title: "央行动态", selected: false)]

    private(set) var filter2: [(title: String, selected: Bool)]  = [(title: "全部", selected: true), (title: "新股上市", selected: false), (title: "新股申购", selected: false), (title: "休市提醒", selected: false), (title: "新债上市", selected: false), (title: "新债申购", selected: false)]
    
    private(set) var filter: [(title: String, selected: Bool)] 
    //ScrollView picked first day
    private(set) var selectedDate: Date = Date()
    
    private(set) var stockInfolist: [NewStockInfo]
    
    private(set) var ecoInfolist: [NewEcoInfo]
    
    init(tab: Int = 1, selectedDate: Date = Date()) {
        self.tab = tab
        if tab == 0 {
            self.filter = filter1
        } else {
            self.filter = filter2
        }
        self.selectedDate = selectedDate
        self.stockInfolist = []
        self.ecoInfolist = []
        
        var bufferDay = selectedDate
        for _ in 0..<2 {
            let day = bufferDay.getStringID()
            // 1,4
            // 2,5
            // 3
            var stockItems:[[NewStockItem]] = []
            var infoItems:[NewEcoItem] = []

            
            //API to request Stock JSON data, according to date
            for data in RequestData {
                if day == data.day {
                    addStockByFilter(&stockItems, add: data, filteredBy: filter)
                }
            }
            
            //API to request Eco JSON data, according to date
            for data in EcoData {
                if day == data.day {
                    addEcoItemByFilter(&infoItems, add: data, filteredBy: filter)
                }
            }
            
            let indexDayStockInfo: NewStockInfo = NewStockInfo(id: bufferDay, possessData: stockItems.count == 0 ? 0 : 1, stockList: stockItems)
            
            let indexDayEcoInfo: NewEcoInfo = NewEcoInfo(id: bufferDay, possessData: infoItems.count == 0 ? 0 : 1, ecoList: infoItems)
            
            stockInfolist.append(indexDayStockInfo)
            ecoInfolist.append(indexDayEcoInfo)
            
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
    
    
    /// changeFilter
    /// - Parameters:
    ///   - cancelOrSelect: true: Set title to true, false: Set title to false
    ///   - selectedTitle: the Title for located
    mutating func changeFilter(_ cancelOrSelect: Bool, _ selectedTitle: String) {
        
        //Index for change
        let FilterIndex = filter.firstIndex(where: {$0.title == selectedTitle})
        //How many tuples has been set to true
        let selectedCount = filter.filter { $0.selected == true }.count
        
        var changeScrollView = false
        
        //When only selected one filter Item, it can not be cancelled
        if selectedCount == 1 {
            let bufferIndex = filter.firstIndex(where: {$0.selected == true})
            if bufferIndex != FilterIndex {
                if bufferIndex == 0 {
                    filter[bufferIndex!].selected = false
                }
                filter[FilterIndex!].selected = true
                changeScrollView = true
            }
            //else do nothing
        } else {
            filter[FilterIndex!].selected = cancelOrSelect
            changeScrollView = true
        }
        
        //All case
        if FilterIndex == 0 {
            if cancelOrSelect == true {
                filter[0].selected = true
                for i in 1..<filter.count {
                    filter[i].selected = false
                }
                changeScrollView = true
            }
        }
        
        if tab == 0 {
            filter1 = filter
        } else {
            filter2 = filter
        }
        
        if changeScrollView {
            self.changeInfoList()
        }
    }
    
    mutating func changeInfoList() {
        if tab == 0 {
            self.ecoInfolist = []
            var bufferDay = selectedDate
            for _ in 0..<2 {
                let day = bufferDay.getStringID()
                var infoItems:[NewEcoItem] = []
                
                for data in EcoData {
                    if day == data.day {
                        addEcoItemByFilter(&infoItems, add: data, filteredBy: filter)
                    }
                }
                
                let indexDayEcoInfo: NewEcoInfo = NewEcoInfo(id: bufferDay, possessData: infoItems.count == 0 ? 0 : 1, ecoList: infoItems)
        
                ecoInfolist.append(indexDayEcoInfo)
                
                bufferDay = myCalendar.getNextDay(bufferDay)
            }
        } else {
            self.stockInfolist = []
            var bufferDay = selectedDate
            for _ in 0..<2 {
                let day = bufferDay.getStringID()
                var stockItems:[[NewStockItem]] = []
                
                for data in RequestData {
                    if day == data.day {
                        addStockByFilter(&stockItems, add: data, filteredBy: filter)
                    }
                }
                
                let indexDayStockInfo: NewStockInfo = NewStockInfo(id: bufferDay, possessData: stockItems.count == 0 ? 0 : 1, stockList: stockItems)
        
                stockInfolist.append(indexDayStockInfo)
                
                bufferDay = myCalendar.getNextDay(bufferDay)
            }
        }
    }
}

    
func addEcoItemByFilter(_ ecoItems: inout [NewEcoItem], add ecoItem: NewEcoItem, filteredBy filter: [(title: String, selected: Bool)]) {
    let addedType = ecoItem.infoType
    if filter[0].selected == true || filter[addedType].selected == true {
        ecoItems.append(ecoItem)
    }
}
    

func addStockByFilter(_ stockItems: inout [[NewStockItem]], add stock: NewStockItem, filteredBy filter: [(title: String, selected: Bool)]) {
    if validStockByFilter(stock, filteredBy: filter) {
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
    }
    
    func validStockByFilter(_ stock: NewStockItem, filteredBy filter: [(title: String, selected: Bool)]) -> Bool {
        var valid = false
        let addedType = stock.stockType
        
        if filter[0].selected == true || filter[addedType].selected == true {
            valid = true
        }
        
        return valid
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
