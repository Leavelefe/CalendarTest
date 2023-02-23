//
//  CircleView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/21.
//

import SwiftUI

/// Part of the logic and var retained in the CircleView will be put into the Model and ViewModel respectively
struct CircleView: View {
    let day: DayModel
    
    var body: some View {
        let circleColor: Color = day.toDO ? .white : .mint
        ZStack {
            let circleShape = Circle()
            let textData = day.isToday ? "今" : String(day.date.get(.day))
            let textColor: Color = resolvingTextColor()
            let backgroundColorSetting = resolvingBackgroundColorSetting()
            
            circleShape.foregroundColor(backgroundColorSetting)
            Text(textData)
                .foregroundColor(textColor)
        }.overlay(Circle().foregroundColor(circleColor).frame(height: 7).offset(y: 10) ,alignment: .bottom).padding(8).transition(.empty)
//            Spacer()
//
//
//            Circle().scale(0.3).foregroundColor(circleColor).padding(0)
    }
    
    func resolvingBackgroundColorSetting() -> Color {
        var backgroudColor: Color = day.isToday ? .mint : .white
        if day.picked {
            backgroudColor = .blue
        }
        return backgroudColor
    }
    
    func resolvingTextColor() -> Color {
        var textColor: Color = day.picked ? .white : .black
        if !day.isCurrentMonth{
            textColor = .gray
        }
        return textColor
    }
}
