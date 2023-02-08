//
//  DayModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/8.
//

import Foundation

/// Under Construction
struct DayModel {
    private(set) var picked: Bool = false
    private(set) var isToday: Bool = false
    private(set) var toDO: Bool = false
    private(set) var isThisMonth: Bool = true
    private(set) var today: Day
    
    func choose(_ day: Day) {
        
    }
    
    //init
//    init() {
//        today = Day(Date()
//        
//    }
    
    struct Day: Identifiable {
        var date: Date
        var id: Int
    }
}

struct WeekDay {
    
}
