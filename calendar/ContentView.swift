//
//  ContentView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/6.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var calendarEventManager = CalendarEventManager()
    
    var body: some View {
        VStack (spacing: 0){
            CalendarView(viewModel: calendarEventManager.firstViewModel).layoutPriority(100)
            EventTabView(viewModel: calendarEventManager)
                .background(Color.gray.brightness(0.4).opacity(1))
            EventScrollView(viewModel: calendarEventManager).layoutPriority(10)
                .background(Color.gray.brightness(0.4).opacity(1))
        }
    }
}

public typealias Weekday = String

extension Weekday: Identifiable {
    public var id: String {
        self
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

