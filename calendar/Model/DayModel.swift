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
struct DayModel {
    private(set) var picked: Bool = false
    private(set) var isToday: Bool = false
    private(set) var toDO: Bool = false
    //Whether this day belongs to current display month
    private(set) var isCurrentMonth: Bool = false
    
    //init
//    init() {
//        today = Day(Date()
//        
//    }
    
}
