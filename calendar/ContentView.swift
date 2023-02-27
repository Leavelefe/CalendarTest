//
//  ContentView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/6.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var calendarEventManager = CalendarEventManager()
    @State var swipeActionAnimation: Int = 1
    
    var body: some View {
        VStack (spacing: 0){
            CalendarView(viewModel: calendarEventManager.firstViewModel, cancelSuperViewSwipeAnimation: $swipeActionAnimation).layoutPriority(100)
                //.animation(nil, value: swipeActionAnimation)
            EventTabView(viewModel: calendarEventManager)
                .background(Color.gray.brightness(0.4).opacity(1))
                .animation(.none, value: swipeActionAnimation)
            EventScrollView(viewModel: calendarEventManager, cancelSwipeAnimation: $swipeActionAnimation).layoutPriority(10)
                .background(Color.gray.brightness(0.4).opacity(1))
                .animation(.none, value: swipeActionAnimation)
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

