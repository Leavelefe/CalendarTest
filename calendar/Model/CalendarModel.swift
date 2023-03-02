//
//  CalendarModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/8.
//

import Foundation


///CalendarManageViewModel 的直属模型
///用于构建整个日历模型
///核心维护daySet_Series数组
struct CalendarModel {
    private(set) var today: Date = Date()
    private(set) var mode: ModeType = .Week
    private(set) var locatedDay: Date
    private(set) var lengthNotEqual = false
    
    /// 1 - Monday 2-Tueday ......
    private(set) var locatedIndex: Int? {
        get {
            let locatedIndices = daySet_Series.indices.filter({daySet_Series[$0].picked})
            return locatedIndices.oneAndOneOnly
        }
        
        set {
            
        }
    }
    
    
    //
    private(set) var daySet_Series: Array<DayModel>
//    private(set) var daySet_Series2: Array<DayModel>
//    private(set) var daySet_Series3: Array<DayModel>
    
    
    init(beigningMode: ModeType = .Week, updateDate: Date = Date()) {
        mode = beigningMode
        daySet_Series = Array<DayModel>()
        locatedDay = updateDate
        //locatedIndex = getLocatedIndex(date: today)
        let daySet = beigningMode == .Month ? myCalendar.monthDays(oneDay: locatedDay) : myCalendar.weekDays(oneDay: locatedDay)
        //print(toDoData)
        for index in 0..<daySet.count {
            let isCurrentMonth: Bool = mode == .Month ? myCalendar.isCurrentMonth(is: daySet[index], equalto: locatedDay) : true
            let isToday: Bool = myCalendar.isSameDay(is: daySet[index], equalto: today)
            let isSelectedDay: Bool = myCalendar.isSameDay(is: daySet[index], equalto: updateDate)
            if isSelectedDay {
                locatedIndex = index
            }
            let toDo = analyzeDataToDo(for: daySet[index])
            daySet_Series.append(DayModel(id: index, picked: isSelectedDay, isToday: isToday, toDO: toDo!, isCurrentMonth: isCurrentMonth, date: daySet[index]))
        }
                    
    }
    
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
    /// - Parameter isPrevios: Judge the swipe direction
    mutating func changeMonthOrWeek(_ isPrevios: Bool) {
        let bufferLength: Int = Int(ceil(Double(daySet_Series.count / 7)))
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
        let currentLength: Int = Int(ceil(Double(daySet_Series.count / 7)))
        if bufferLength == currentLength {
            lengthNotEqual = true
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
            daySet_buffer.append(DayModel(id: index, picked: false, isToday: isToday, toDO: analyzeDataToDo(for: daySet[index])!, isCurrentMonth: isCurrentMonth, date: daySet[index]))
        }
        return daySet_buffer
    }
}

enum ModeType{
    case Month
    case Week
}
