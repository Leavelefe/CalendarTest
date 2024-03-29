//
//  JSONData.swift
//  calendar
//
//  Created by 王峥 on 2023/2/17.
//

import Foundation


//模拟股票理财事件数据
let RequestStockData = getStockItems()!

//模拟宏观财经事件数据
let EcoData = getEcoInfoItems()!

//模拟日历事件数据
let toDoData = readToDoDataFromJSONFile()!


/// 通过Bundle读取股票理财事件JSON数据
/// - Returns: 返回Data类型JSON数据包
func readEventDataFromJSONFile() -> Data? {
    let bundle = Bundle.main
    guard let jsonPath = bundle.path(forResource: "EventData", ofType: "geojson") else {
        print("Error: EventData.json file not found in bundle")
        return nil
    }
    return try? Data(contentsOf: URL(fileURLWithPath: jsonPath))
}

/// 通过Bundle读取宏观财经事件JSON数据
/// - Returns: 返回Data类型JSON数据包
func readEcoDataFromJSONFile() -> Data? {
    let bundle = Bundle.main
    guard let jsonPath = bundle.path(forResource: "EcoData", ofType: "geojson") else {
        print("Error: EcoData.json file not found in bundle")
        return nil
    }
    return try? Data(contentsOf: URL(fileURLWithPath: jsonPath))
}

/// 通过Bundle读取宏观财经事件JSON数据
/// - Returns: 返回Data类型JSON数据包
func readToDoDataFromJSONFile() -> [[String: Any]]? {
    if let path = Bundle.main.path(forResource: "ToDoData", ofType: "geojson"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let array = json as? [[String: Any]] {
        return array
    }
    return nil
}


/// 将JSON数据解包为[NewStockItem]
/// - Returns: [NewStockItem]
func getStockItems() -> [NewStockItem]? {
    guard let jsonData = readEventDataFromJSONFile() else {
        // 无法读取 JSON 文件
        return nil
    }
    do {
        let decoder = JSONDecoder()
        
        let newStockItems = try decoder.decode([NewStockItem].self, from: jsonData)
        //print(newStockItems)
        return newStockItems
        // 解码成功，可以使用 newStockItems 数组了
    } catch {
        // 解码失败，处理错误
        print("Error decoding JSON: \(error)")
        print("Error decoding JSON: \(error.localizedDescription)")
        return nil
    }

}

/// 将JSON数据解包为[NewEcoItem]
/// - Returns: [NewEcoItem]
func getEcoInfoItems() -> [NewEcoItem]? {
    guard let jsonData = readEcoDataFromJSONFile() else {
        // 无法读取 JSON 文件
        return nil
    }
    do {
        let decoder = JSONDecoder()
        
        let newEcoItems = try decoder.decode([NewEcoItem].self, from: jsonData)
        //print(newEcoItems)
        return newEcoItems
        // 解码成功，可以使用 newStockItems 数组了
    } catch {
        // 解码失败，处理错误
        print("Error decoding JSON: \(error)")
        print("Error decoding JSON: \(error.localizedDescription)")
        return nil
    }

}

/// 检验该日期是否存在股票理财事件或者宏观财经事件
/// - Returns: 存在为true，不存在为false
func analyzeDataToDo(for date: Date) -> Bool? {
    let bufferString = date.getStringID()
    for dict in toDoData {
        if let dateString = dict["time"] as? String,
            let todo = dict["todo"] as? Int{
            // 检查日期和 todo 值
            if dateString == bufferString && todo == 1 {
                return true
            }
            if dateString > bufferString {
                return false
            }
        }
    }
    return false
}


//let EcoData = [NewEcoItem(id: "111", day: "20230222", title: "十三届全国人大常委会第三十九届会议", content: "十三届全国人大常委会第三十九届会议2月23日至24日在北京举行", infoType: 3),
//               NewEcoItem(id: "222", day: "20230223", title: "2022年国民经济和社会发展统计公报", infoType: 1),
//               NewEcoItem(id: "333", day: "20230223", time: "00:00", title: "新西兰联储官方现金利率预告", previosValue: 3.5, infoType: 4)]
