//
//  DayModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/8.
//

import Foundation

/// Daymodel
/// Only Delare day strcture data
/// Haven't involve bussiness data
///
struct DayModel: Identifiable {
    var id: Int
    var picked: Bool = false
    var isToday: Bool = false
    var toDO: Bool = false
    //Whether this day belongs to current display month
    var isCurrentMonth: Bool = false
    
    var date: Date
    
    //init
//    init() {
//        today = Day(Date()
//        
//    }
    
}
