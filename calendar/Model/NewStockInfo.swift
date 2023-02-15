//
//  NewStockInfo.swift
//  calendar
//
//  Created by 王峥 on 2023/2/14.
//

import Foundation


struct NewStockInfo: Identifiable {
    //DateString format
    var id: String
    // 0 - 无
    // 1 - 新股上市
    // 2 - 新股申购
    // 3 - 休市提醒
    // 4 - 新债上市
    // 5 - 新债申购
    private(set) var stockType: Int
    private(set) var stockList: [NewStockItem]
}

struct NewStockItem: Identifiable {
    //Stock ID
    var id: String?
    var stockName: String?
    var stockPrice: Float?
    var stockType: Int?
    
}
