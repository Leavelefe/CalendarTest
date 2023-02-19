//
//  ContentView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/6.
//

import SwiftUI

struct ContentView: View {
    let calendarTopViewModel = CalendarManageViewModel()
    
    let calendarEventManager = CalendarEventManager()
    var body: some View {
        VStack {
            CalendarView(viewModel: calendarTopViewModel).layoutPriority(100)
            Index(viewModel: calendarEventManager)
            buffer(viewModel: calendarEventManager).layoutPriority(10)
        }
    }
}

extension Animation {
    static func ripple() -> Animation {
        Animation.spring(dampingFraction: 0.7)
    }
}

public typealias Weekday = String

extension Weekday: Identifiable {
    public var id: String {
        self
    }
}

/// Part of the logic and var retained in the CalendarView will be put into the Model and ViewModel respectively
struct CalendarView: View {
    @ObservedObject var viewModel: CalendarManageViewModel
    
    var weeks: [Weekday] = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    @State var direction = ""
    @State var showAnimation: Bool = false
    
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
//            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 30)), count: 7)) {
//                ForEach(weeks[0..<7], id: \.self) { weekday in
//                    Text(weekday).font(.system(size: 10)).foregroundColor(.gray)
//                }
//                ForEach(viewModel.days) { day in
//                    CircleView(day: day).onTapGesture {
//                        viewModel.choose(day)
//                        withAnimation{viewModel.swithMode(.Week)}
//                    }
//                }
            
//                ForEach(days[0..<7], id: \.self) { day in
//                    CircleView(content: day)
//                }
            //}
//            .padding(.horizontal)
//            //.layoutPriority(100)
//            .onSwipe{ direction in
//                    viewModel.swipeMonthOrWeek(direction)
//                }
            CalendarWeekListView(items: weeks) {
                weekday in
                    Text(weekday).font(.system(size: 10)).foregroundColor(.gray)
            }
            
            CalendarWeekListView(items: viewModel.days) {
                day in
                CircleView(day: day)
                    .padding(2)
                    //.transition(.testAction)
                    .onTapGesture {
                    viewModel.choose(day)
                    viewModel.swithMode(.Week)
                    showAnimation.toggle()
                    }.animation(nil)
                    
            }
            .onSwipe{ direction in
                viewModel.swipeMonthOrWeek(direction)
                showAnimation.toggle()
            }
            //.transition(.testAction)
            //.animation(.ripple())
            
            
            ZStack{
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 5).frame(height: 25).foregroundColor(.white)
                    Spacer()
                }.onTapGesture {
                    viewModel.swithMode(viewModel.mode == .Month ? .Week : .Month)
                    showAnimation.toggle()
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
                        viewModel.BackToToday()
                        showAnimation.toggle()
                    }
                }
            }
            Divider()
        }
        //.transition(.testAction)
        .animation( .easeInOut(duration: 0.5), value: showAnimation)
    }
    
    var week: some View {
        Button( action: {
            viewModel.swithMode(.Week)
            showAnimation.toggle()
        }){
            Text("周")
                .foregroundColor(viewModel.mode == .Week ? .black : .gray)
        }
    }
    var month: some View {
        Button( action: {
            viewModel.swithMode(.Month)
            showAnimation.toggle()
        }){
            Text("月")
                .foregroundColor(viewModel.mode == .Week ? .gray : .black)
        }
    }
}

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
        }.overlay(Circle().foregroundColor(circleColor).frame(height: 7).offset(y: 10) ,alignment: .bottom).padding(8)
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

/// Part of the logic and var retained in the Index will be put into the Model and ViewModel respectively
struct Index: View {
    @ObservedObject var viewModel: CalendarEventManager
    
    private let segmented = ["宏观财经", "股票理财"]
    @State private var selector = 1
    @State private var showSelections: Bool = false
    var body: some View{
        VStack{
            HStack{
                ForEach(segmented, id: \.self) { name in
                    Button(action: {
                        if let index = segmented.firstIndex(of: name){
                            withAnimation {
                                selector = index
                            }
                            viewModel.switchTab()
                        }
                    }, label: {
                        if selector == segmented.firstIndex(of: name){
                            Text(name)
                                .font(.system(size: 18, weight: .bold))
                                .overlay(LinearGradient(gradient:
                                                            Gradient(colors: [.blue,.red, .yellow]),
                                                            startPoint: .leading,
                                                            endPoint: .trailing)
                                    .frame(height: 6).offset(y: 4) ,alignment: .bottom).foregroundColor(.black)
                        }else{
                            Text(name)
                                .foregroundColor(.gray)
                        }
                    })
                }
                Spacer()
                HStack{
                    if showSelections {
                        Image(systemName: "xmark").font(.system(size: 12))
                    } else {
                        Image(systemName: "star").font(.system(size: 10))
                            .padding(.trailing, -5)
                        Text("筛选").font(.system(size: 11))
                    }
                }.foregroundColor(.blue)
                    .onTapGesture {
                        withAnimation {
                            showSelections.toggle()
                        }
                    }
            }
            .padding()
            if showSelections {
                HStack {
                    VStack {
                        HStack {
                            Text("默认订阅").padding().foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 80), spacing: 0), count: 4), spacing: 10) {
                                ForEach(Array(viewModel.filterContent), id: \.key) {
                                    key, value in
                                    FilterButton(selected: value == 1 ? true : false, content: key)
                                }
                            }
                        }.padding(.bottom, 10)
                    }
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 1.0))
        .shadow(radius: 1, x: 0, y: 0)
    }
}

struct buffer: View {
    @ObservedObject var viewModel: CalendarEventManager
    var body: some View {
        ScrollView {
            ForEach(viewModel.infos) { info in
                StockFinancialView(info: info)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
            
    }
}








public struct SwipeGesture: Gesture {
    public enum Direction: String {
        case left, right, none
    }

    public typealias Value = Direction

    private let minimumDistance: CGFloat
    private let coordinateSpace: CoordinateSpace

    public init(minimumDistance: CGFloat = 10, coordinateSpace: CoordinateSpace = .local) {
        self.minimumDistance = minimumDistance
        self.coordinateSpace = coordinateSpace
    }

    public var body: AnyGesture<Value> {
        AnyGesture(
            DragGesture(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace)
                .map { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height

                    if abs(horizontalAmount) > abs(verticalAmount) {
                        if horizontalAmount < 0 { return .left } else { return .right }
                    } else {
                        return .none
                    }
                }
        )
    }
}

public extension View {
    func onSwipe(minimumDistance: CGFloat = 10,
                 coordinateSpace: CoordinateSpace = .local,
                 perform: @escaping (SwipeGesture.Direction) -> Void) -> some View {
        gesture(
            SwipeGesture(minimumDistance: minimumDistance, coordinateSpace: coordinateSpace)
                .onEnded(perform)
        )
    }
}
