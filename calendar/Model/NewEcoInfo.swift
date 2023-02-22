//
//  NewEcoInfo.swift
//  calendar
//
//  Created by 王峥 on 2023/2/20.
//

import Foundation


struct NewEcoInfo: Identifiable {
    // Date should be id for NewEcoInfo
    private(set) var id: Date
    // 0 - 无
    // 1 - 有
    private(set) var possessData: Int
    private(set) var ecoList: [NewEcoItem]?
}

struct NewEcoItem: Identifiable, Hashable {
    //Info ID
    var id: String
    //YYYYMMDD
    var day: String
    //00:00
    var time: String?
    var title: String
    var content: String?
    
    var todayValue: Float?
    var previosValue: Float?
    var nextValue: Float?
    
    // 1 - 经济指标
    // 2 - 活动预告
    // 3 - 财经会议
    // 4 - 央行动态
    var infoType: Int
    
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
}
