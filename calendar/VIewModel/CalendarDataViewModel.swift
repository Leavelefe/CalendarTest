//
//  CalendarDataViewModel.swift
//  calendar
//
//  Created by 王峥 on 2023/2/28.
//

import SwiftUI
import Foundation

class CalendarDataViewModel: ObservableObject {
    private let customizedCalendarData = CustomizedCalendarData.shared
    @Published var events: [CustomizedCalendarEvent] = []

    init() {
        // 从 UserDefaults 中获取已保存的事件
        let keys = UserDefaults.standard.dictionaryRepresentation().keys
        for key in keys {
            if let event = customizedCalendarData.getCalendarEvent(key) {
                events.append(event)
            }
        }
    }
        
    func saveEventByKey(set event: CustomizedCalendarEvent, byKey id: String  ) {
        if let index = events.firstIndex(where: { $0.id == id }) {
            events[index] = event
        } else {
            events.append(event)
        }
        customizedCalendarData.setCalendarEvent(event, forID: id)
        self.objectWillChange.send()
    }
    
    func retrivedEventByKey(byKey id: String) -> CustomizedCalendarEvent?{
        events.first(where: { $0.id == id })
    }
    
    func generateEventBufferData(title: String, date: Date, eventType: Int, repeatType: Repeat = .OnlyToday, reminderType: Reminder = .WhenItHappend, id: String?) -> CustomizedCalendarEvent {
        var bufferID: String = generateRandomID()
        if let id = id {
            bufferID = id
        }
        return CustomizedCalendarEvent(title: title, date: date, eventType: eventType, repeatType: repeatType, reminderType: reminderType, id: bufferID)
    }
    
    private func generateRandomID() -> String {
        var randomID: String
        repeat {
            randomID = UUID().uuidString
        } while events.contains { $0.id == randomID }
        return randomID
    }
    
    func haveCustomizedDataInThatDay(dateID: String) -> Bool {
        if events.firstIndex(where: { $0.date.getStringID() == dateID && $0.eventType == 3}) != nil {
            return true
        }
        return false
    }
    
    func returnCustomizedDataEvents(dateID: String) -> [CustomizedCalendarEvent] {
        var result: [CustomizedCalendarEvent] = []
        for event in events {
            if event.date.getStringID() == dateID && event.eventType == 3 {
                result.append(event)
            }
        }
        return result
    }
}
