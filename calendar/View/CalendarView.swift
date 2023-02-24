//
//  CalendarView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/23.
//

import SwiftUI

/// Part of the logic and var retained in the CalendarView will be put into the Model and ViewModel respectively
struct CalendarView: View {
    @ObservedObject var viewModel: CalendarManageViewModel
    @State private var offset: CGFloat = 0
    @State private var changeMonth = 1
    @State private var cancelSwipeAnimation = 1
    
    var weeks: [Weekday] = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    @State var direction = ""
    //@State var showAnimation: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.TopTextDate)
                Spacer()
                week
                Text("｜").padding(.horizontal, -10.0)
                month
            }
            .padding(.horizontal)
            
            CalendarWeekListView(items: weeks) {
                weekday in
                    Text(weekday).font(.system(size: 10)).foregroundColor(.gray)
            }
            
            ZStack {
                CalendarWeekListView(items: viewModel.days) {
                    day in
                    CircleView(day: day)
                        .padding(2)
                        //.transition(.testAction)
                        .onTapGesture {
                            viewModel.choose(day)
                            withAnimation {
                                viewModel.swithMode(.Week)
                            }
                        }//.animation(nil)
                        .animation(nil, value: changeMonth)
                        .animation(nil, value: cancelSwipeAnimation)
                        
                }
                .offset(x: offset)
                .transition(.offset(x: offset > 0 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width))
                .animation(nil, value: cancelSwipeAnimation)
                if offset != 0 {
                    CalendarWeekListView(items: viewModel.previousOrNextDays(isPreious: offset > 0)) {
                        day in
                        CircleView(day: day)
                            .padding(2)
                            //.transition(.testAction)
                            .onTapGesture {
                                viewModel.choose(day)
                                withAnimation {
                                    viewModel.swithMode(.Week)
                                }
                            }.transition(.empty)
                            .animation(nil, value: cancelSwipeAnimation)
                            
                    }.offset(x: offset - (offset > 0 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width))
                        .transition(.offset(x: offset < 0 ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width))
                        .animation(nil, value: cancelSwipeAnimation)
                }
            }
            //.animation(.easeInOut(duration: 1))
            .gesture(DragGesture()
                .onChanged { value in
                    self.offset = value.translation.width
                }
                .onEnded { value in
                    let dragDistance = value.translation.width
                    let screenWidth = UIScreen.main.bounds.width
                    let isLeft = dragDistance < 0
                    
                    if abs(dragDistance) > screenWidth / 3 || (abs(dragDistance) > 10 && isLeft != (offset < 0)) {
                        withAnimation() {
                            if isLeft {
                                offset = -screenWidth
                            } else {
                                offset = screenWidth
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation {
                                viewModel.swipeMonthOrWeek(isLeft)
                                cancelSwipeAnimation += 1
                            }
                            offset = 0
                        }
                        
                    } else {
                        withAnimation() {
                            offset = 0
                        }
                    }
                }
            ).transition(.empty)
//            .onSwipe{ direction in
//                withAnimation {
//                    viewModel.swipeMonthOrWeek(direction)
//                }
//            }
            //.transition(.testAction)
            //.animation(.ripple())
            
            
            ZStack{
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 5).frame(height: 25).foregroundColor(.white)
                    Spacer()
                }.onTapGesture {
                    withAnimation {
                        viewModel.swithMode(viewModel.mode == .Month ? .Week : .Month)
                        changeMonth += 1
                    }
                }
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 5).frame(width: 20, height: 3).foregroundColor(.gray)
                    Spacer()
                }
                
                if viewModel.mode == .Month {
                    HStack {
                        Text("查看今天").foregroundColor(.blue).padding(.leading)
                        Spacer()
                    }.onTapGesture {
                        withAnimation {
                            viewModel.BackToToday()
                        }
                    }
                }
            }
        }
        .background(Color.white)
        //.transition(.testAction)
        //.animation( .easeInOut(duration: 0.5), value: showAnimation)
    }
    
    var week: some View {
        Button( action: {
            withAnimation {
                viewModel.swithMode(.Week)
            }
        }){
            Text("周")
                .foregroundColor(viewModel.mode == .Week ? .black : .gray)
        }
    }
    var month: some View {
        Button( action: {
            withAnimation() {
                viewModel.swithMode(.Month)
                changeMonth += 1
            }
        }){
            Text("月")
                .foregroundColor(viewModel.mode == .Week ? .gray : .black)
        }
    }
}


