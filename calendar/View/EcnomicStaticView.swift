//
//  EcnomicStaticView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/14.
//

import SwiftUI

struct EcnomicStaticView: View {
    let info: NewEcoInfo
    
    var body: some View {
        VStack(spacing: 5) {
            DateView(chooseDay: info.id)
            
            if info.possessData == 1 {
                ForEach(info.ecoList!, id: \.self) {
                    ecoItem in
                    StockStyleStack {
                        VStack {
                            EcoTitleView(item: ecoItem)
                            //If content exist
                            EcoContentView(item: ecoItem)
                        }
                    }
                    
                }
            } else {
                StockStyleStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "calendar.badge.minus")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        Spacer()
                    }.frame(height: 150)
                }
                
            }
        }
    }
}

struct EcoTitleView: View {
    let item: NewEcoItem
    @State private var showingConfirmationSheet = false
    
    var body: some View {
        HStack (spacing: 0) {
            //如果存在指定时间值
            if let timeData = item.time {
                Text(timeData)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
            }
            
            //Title
            Text(item.title).font(.system(size: 20, weight: .medium))
                .padding(.bottom, 10)
                .padding(.top, 30)
                .padding(.leading)
                .padding(.trailing, 0)
            
            
            Spacer()
            
            Image(systemName: "calendar.badge.plus")
                .foregroundColor(.gray)
                .padding(.trailing, 13)
                .padding(.leading, 0)
                .addCalendarEventSheet(title: item.title, date: item.getDate())
        }
    }
}

struct EcoContentView: View {
    let item: NewEcoItem
    
    var body: some View {
        //IF contents
        if let content = item.content {
            Text(content)
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 30)
        }
        //IF contents
        if item.time != nil {
            
            HStack {
                Text("今值")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                if let todayValue = item.todayValue {
                    Text(String(todayValue))
                        .padding(.trailing, 10)
                } else {
                    Text("--")
                        .padding(.trailing, 10)
                }
                Text("前值")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                if let previosValue = item.previosValue {
                    Text(String(previosValue))
                        .padding(.trailing, 10)
                } else {
                    Text("--")
                        .padding(.trailing, 10)
                }
                Text("预值")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                if let nextValue = item.nextValue {
                    Text(String(nextValue))
                        .padding(.trailing, 10)
                } else {
                    Text("--")
                        .padding(.trailing, 10)
                }
            }.padding(.bottom, 25)
        }
    }
}

