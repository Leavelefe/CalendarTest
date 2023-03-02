//
//  FilterButton.swift
//  calendar
//
//  Created by 王峥 on 2023/2/19.
//

import SwiftUI


///筛选控件
struct FilterButton: View {
    @StateObject var viewModel: CalendarEventManager
    
    let content: String
    let selected: Bool
    
    var body: some View {
        if selected {
            Button(content) {
                viewModel.changeFilter(action: false, selectedTitle: content)
            }
            .frame(width: 80, height: 30)
            .font(.system(size: 15))
            .border(Color.gray, width: 0.3)
            .background(Color.blue)
            .foregroundColor(.white)
        } else {
            Button(content) {
                viewModel.changeFilter(action: true, selectedTitle: content)
            }
            .frame(width: 80, height: 30)
            .font(.system(size: 15))
            .border(Color.gray, width: 0.3)
            .background(Color.white)
            .foregroundColor(.gray)
        }
    }
}


