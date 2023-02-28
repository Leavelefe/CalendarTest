//
//  CusomizedCalendarData.swift
//  calendar
//
//  Created by 王峥 on 2023/2/28.
//

import Foundation

class CustomizedCalendarData {
    static let shared = CustomizedCalendarData()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func getCalendarEvent(_ calendarEventKey: String) -> CustomizedCalendarEvent? {
        guard let data = userDefaults.data(forKey: calendarEventKey) else {
            return nil
        }
        return try? PropertyListDecoder().decode(CustomizedCalendarEvent.self, from: data)
    }
    
    func setCalendarEvent(_ event: CustomizedCalendarEvent?, forID calendarEventKey: String) {
        let data = try? PropertyListEncoder().encode(event)
        userDefaults.set(data, forKey: calendarEventKey)
    }
}




struct CustomizedCalendarEvent: Codable {
    var title: String
    var date: Date
    var eventType: Int
    var id: String
    var repeatType: Repeat
    var reminderType: Reminder
    
    init(title: String, date: Date, eventType: Int, repeatType: Repeat, reminderType: Reminder, id: String) {
        self.title = title
        self.date = date
        self.eventType = eventType
        self.repeatType = repeatType
        self.reminderType = reminderType
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case id
        case eventType
        case repeatType
        case reminderType
    }
    
    // 实现Encodable协议的方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(id, forKey: .id)
        try container.encode(eventType, forKey: .eventType)
        try container.encode(repeatType.rawValue, forKey: .repeatType)
        try container.encode(reminderType.rawValue, forKey: .reminderType)
    }
    
    // 实现Decodable协议的方法
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        id = try container.decode(String.self, forKey: .id)
        eventType = try container.decode(Int.self, forKey: .eventType)
        repeatType = try Repeat(rawValue: container.decode(String.self, forKey: .repeatType)) ?? .OnlyToday
        reminderType = try Reminder(rawValue: container.decode(String.self, forKey: .reminderType)) ?? .WhenItHappend
    }
}


enum Repeat: String, CaseIterable, Identifiable {
    case OnlyToday, EveryDay, EveryWeek, EveryMonth
    var id: Self { self }
}

enum Reminder: String, CaseIterable, Identifiable {
    case WhenItHappend, FiveMinutesEarly, FifteenMinutesEarly, HarfHourEarly, OneHourEarly
    var id: Self { self }
}


func getRelatedRepeatText(_ repeatType: Repeat) -> String {
    let dataSet = ["仅此一天", "每日", "每周", "每月"]
    switch repeatType {
        
    case .OnlyToday:
        return dataSet[0]
    case .EveryDay:
        return dataSet[1]
    case .EveryWeek:
        return dataSet[2]
    case .EveryMonth:
        return dataSet[3]
    }
}


func getRelatedReminderText(_ reminderType: Reminder) -> String {
    let dataSet = ["事件发生时", "5分钟前", "15分钟前", "30分钟前", "1小时前"]
    switch reminderType {
        
    case .WhenItHappend:
        return dataSet[0]
    case .FiveMinutesEarly:
        return dataSet[1]
    case .FifteenMinutesEarly:
        return dataSet[2]
    case .HarfHourEarly:
        return dataSet[3]
    case .OneHourEarly:
        return dataSet[4]
    }
}
