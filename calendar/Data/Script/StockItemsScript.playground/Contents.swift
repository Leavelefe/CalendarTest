import Foundation

func generateRandomStockItems(count: Int) -> [[String: Any]] {
    var idSet = Set<String>()
    var stockItems: [[String: Any]] = []
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    var day = formatter.date(from: "20230101")!
    
    for _ in 0..<count {
        var id = ""
        repeat {
            let numbers = "0123456789"
            id = String((0..<6).map{ _ in numbers.randomElement()! })
        } while idSet.contains(id)
        idSet.insert(id)
        
        repeat {
                    day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
                } while Calendar.current.isDateInWeekend(day) && day.timeIntervalSinceNow < TimeInterval(60 * 60 * 24 * 2)
        let dayString = formatter.string(from: day)
        
        let time: String
        var stockType: Int
        repeat {
            stockType = Int.random(in: 1...5)
        } while stockType == 3
        if Calendar.current.isDateInWeekend(day) {
            time = "00:00"
            stockType = 3
        } else {
            let hour = Int.random(in: 9...11)
            let minute = Int.random(in: 0...59)
            time = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute))"
        }
        
        let stockName = "\(String((0..<2).map{ _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()! }))申购"
        let stockPrice = String(format: "%.2f", Double.random(in: 0...100))
        
        let stockItem: [String: Any] = [
            "id": id,
            "day": dayString,
            "time": time,
            "stockName": stockName,
            "stockPrice": stockPrice,
            "stockType": stockType
        ]
        stockItems.append(stockItem)
    }
    
    return stockItems
}

let stockItems = generateRandomStockItems(count: 200)

let fileManager = FileManager.default
let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
let fileURL = documentDirectory.appendingPathComponent("EventData.json")

do {
    let jsonData = try JSONSerialization.data(withJSONObject: stockItems, options: .prettyPrinted)
    try jsonData.write(to: fileURL)
    print("File saved to \(fileURL.path)")
} catch {
    print("Error writing data: \(error.localizedDescription)")
}
