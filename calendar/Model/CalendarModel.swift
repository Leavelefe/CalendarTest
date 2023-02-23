//
//  CalendarModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/8.
//

import Foundation


/// Under Construction
struct CalendarModel {
    private(set) var today: Date = Date()
    private(set) var mode: ModeType = .Week
    private(set) var locatedDay: Date
    
    /// 1 - Monday 2-Tueday ......
    private(set) var locatedIndex: Int? {
        get {
            let locatedIndices = daySet_Series.indices.filter({daySet_Series[$0].picked})
            return locatedIndices.oneAndOneOnly
        }
        
        set {
            
        }
    }
    
    
    //Mark: Store structure under construction
    private(set) var daySet_Series: Array<DayModel>
//    private(set) var daySet_Series2: Array<DayModel>
//    private(set) var daySet_Series3: Array<DayModel>
    
    /// <#Description#>
    init(beigningMode: ModeType = .Week, updateDate: Date = Date()) {
        mode = beigningMode
        daySet_Series = Array<DayModel>()
        locatedDay = updateDate
        //locatedIndex = getLocatedIndex(date: today)
        let daySet = beigningMode == .Month ? myCalendar.monthDays(oneDay: locatedDay) : myCalendar.weekDays(oneDay: locatedDay)
        //print(daySet)
        //Mark: daySet_Series Detial need be filled later
        for index in 0..<daySet.count {
            let isCurrentMonth: Bool = mode == .Month ? myCalendar.isCurrentMonth(is: daySet[index], equalto: locatedDay) : true
            let isToday: Bool = myCalendar.isSameDay(is: daySet[index], equalto: today)
            let isSelectedDay: Bool = myCalendar.isSameDay(is: daySet[index], equalto: updateDate)
            if isSelectedDay {
                locatedIndex = index
            }
            daySet_Series.append(DayModel(id: index, picked: isSelectedDay, isToday: isToday, isCurrentMonth: isCurrentMonth, date: daySet[index]))
        }
                    
    }
    
    //Mark: Under Construction
      //Month Status picked need be set to week, in that case, the mode need be changed
      //
//    private func getLocatedIndex(date: Date) -> Int {
//        date.get(.weekday) <= 1 ? 7 - date.get(.weekday) : date.get(.weekday) - 1
//    }
    
    mutating func choose(_ day: DayModel) {
        if let chooseIndex = daySet_Series.firstIndex(where: {$0.id == day.id}),
            daySet_Series[chooseIndex].isCurrentMonth
        {
            if let defaultPickedDateIndex = locatedIndex {
                daySet_Series[defaultPickedDateIndex].picked = false
                locatedIndex = chooseIndex
                daySet_Series[chooseIndex].picked.toggle()
                locatedDay =  daySet_Series[chooseIndex].date
//                if mode == .Month {
//                    self.swithMode(.Week)
//                }
            } else {
                locatedIndex = chooseIndex
                daySet_Series[chooseIndex].picked.toggle()
                locatedDay =  daySet_Series[chooseIndex].date
            }
        }
    }
    
    mutating func swithMode(_ newMode: ModeType) {
        let pickDate = locatedDay
        self = .init(beigningMode: newMode, updateDate: pickDate)
    }
    
    
    /// Swipe to the next or previos month or week
    /// - Parameter newMode:
    mutating func changeMonthOrWeek(_ isPrevios: Bool) {
        if mode == .Week {
            if isPrevios {
                self = .init(beigningMode: .Week, updateDate: myCalendar.previousWeek(locatedDay))
            } else {
                self = .init(beigningMode: .Week, updateDate: myCalendar.nextWeek(locatedDay))
            }
        } else {
            if isPrevios {
                self = .init(beigningMode: .Month, updateDate: myCalendar.previousMonth(locatedDay))
            } else {
                self = .init(beigningMode: .Month, updateDate: myCalendar.nextMonth(locatedDay))
            }
        }
    }
    
    mutating func BackToToday() {
        self = .init()
    }
    
    func returnPreviousOrNextDays(isPrevios: Bool) -> Array<DayModel> {
        var bufferDate: Date? = nil
        if mode == .Week {
            if isPrevios {
                bufferDate = myCalendar.previousWeek(locatedDay)
            } else  {
                bufferDate = myCalendar.nextWeek(locatedDay)
            }
        } else {
            if isPrevios {
                bufferDate = myCalendar.previousMonth(locatedDay)
            } else {
                bufferDate = myCalendar.nextMonth(locatedDay)
            }
        }
        
        let daySet_buffer = createDaySets(selectedMode: mode, pickedDate: bufferDate!)
        return daySet_buffer
    }
    
    func createDaySets(selectedMode: ModeType, pickedDate: Date) -> Array<DayModel> {
        var daySet_buffer = Array<DayModel>()
        
        let daySet = selectedMode == .Month ? myCalendar.monthDays(oneDay: pickedDate) : myCalendar.weekDays(oneDay: pickedDate)
        
        for index in 0..<daySet.count {
            let isCurrentMonth: Bool = mode == .Month ? myCalendar.isCurrentMonth(is: daySet[index], equalto: pickedDate) : true
            let isToday: Bool = myCalendar.isSameDay(is: daySet[index], equalto: today)
//            if isSelectedDay {
//                locatedIndex = index
//            }
            daySet_buffer.append(DayModel(id: index, picked: false, isToday: isToday, isCurrentMonth: isCurrentMonth, date: daySet[index]))
        }
        return daySet_buffer
    }
}

enum ModeType{
    case Month
    case Week
}
