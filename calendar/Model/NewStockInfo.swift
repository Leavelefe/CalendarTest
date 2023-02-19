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
    
}
