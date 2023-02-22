//
//  NewStockInfo.swift
//  calendar
//
//  Created by 王峥 on 2023/2/14.
//

import Foundation


struct NewStockInfo: Identifiable {
    // Date should be id for NewStockInfo
    private(set) var id: Date
    // 0 - 无
    // 1 - 有
    private(set) var possessData: Int
    private(set) var stockList: [[NewStockItem]]?
}

struct NewStockItem: Identifiable, Hashable {
    //Stock ID
    var id: String?
    //YYYYMMDD
    var day: String
    //HH:MM
    var time: String?
    var stockName: String?
    var stockPrice: Float?
    // 0 - 无
    // 1 - 新股上市 4 - 新债上市
    // 2 - 新股申购 5 - 新债申购
    // 3 - 休市提醒
    var stockType: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(day)
    }
    
    func getDate() -> Date {
        let timeWanted = time != nil ? time! : Date().getHourAndMinutes()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHH:mm"
        if let date = dateFormatter.date(from: (day + timeWanted)) {
            return date
        } else {
            return Date()
        }
    }
    
    func getTitle() -> String {
        var bufferString = ""
        if stockType == 1 {
            bufferString += stockName!
            bufferString += "新股上市"
        } else if stockType == 2 {
            bufferString += stockName!
            bufferString += "新股申购"
        } else if stockType == 3 {
            bufferString += "A股休市；港股通暂停交易"
        } else if stockType == 4 {
            bufferString += stockName!
            bufferString += "新债上市"
        } else if stockType == 5 {
            bufferString += stockName!
            bufferString += "新债申购"
        }
        return bufferString
    }
}
