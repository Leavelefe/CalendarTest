//
//  JSONData.swift
//  calendar
//
//  Created by 王峥 on 2023/2/17.
//

import Foundation

let RequestData = [NewStockItem(id: "889366", day: "20230220", stockName: "普润申购", stockPrice: 8.5, stockType: 2),
                   NewStockItem(id: "832149", day: "20230220", stockName: "利尔达申购", stockPrice: 5, stockType: 1),
                   NewStockItem(id: "603190", day: "20230221", stockName: "亚通申购", stockPrice: 29.09, stockType: 1),
                   NewStockItem(id: "787522", day: "20230221", stockName: "纳睿申购", stockPrice: 46.68, stockType: 2)
]

let EcoData = [NewEcoItem(id: "111", day: "20230220", title: "十三届全国人大常委会第三十九届会议", content: "十三届全国人大常委会第三十九届会议2月23日至24日在北京举行", infoType: 3),
               NewEcoItem(id: "222", day: "20230221", title: "2022年国民经济和社会发展统计公报", infoType: 1),
               NewEcoItem(id: "333", day: "20230221", time: "00:00", title: "新西兰联储官方现金利率预告", previosValue: 3.5, infoType: 4)]
