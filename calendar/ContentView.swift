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
            EventTabView(viewModel: calendarEventManager)
            EventScrollView(viewModel: calendarEventManager).layoutPriority(10)
        }.background(Color.gray.brightness(0.4))
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
        .background(Color.white)
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


struct EventScrollView: View {
    @ObservedObject var viewModel: CalendarEventManager
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var items = Array(0..<10)
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                if viewModel.showEco {
                    ForEach(viewModel.ecoInfos) { info in
                        EcnomicStaticView(info: info)
                    }
                } else {
                    ForEach(viewModel.stockInfos) { info in
                        StockFinancialView(info: info)
                    }
                }
                GeometryReader { geo in
                    Text("test")
                        .foregroundColor(.red)
                        .onAppear {
                            print(geo.frame(in: .global).maxY)
                            print(geo.size.height)
                            print(UIScreen.main.bounds.height)
                            if !isRefreshing && geo.frame(in: .global).maxY <= UIScreen.main.bounds.height {
                                isRefreshing = true
                                // 执行下拉刷新操作
                                print("sadas")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    items.append(contentsOf: [20, 21, 22])
                                    isRefreshing = false
                                }
                            }
                        }
                }
                
            }
        }
    }
    private func refreshControl() -> some View {
        ZStack {
            if isRefreshing {
                ProgressView()
            } else {
                Image(systemName: "arrow.down")
            }
        }
        .frame(width: 30, height: 30)
        .foregroundColor(.blue)
        .padding(.top, -50)
        .opacity(isRefreshing ? 1.0 : 0.5)
        .onTapGesture {
            guard !isRefreshing else { return }
            isRefreshing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                items = Array(0..<10)
                isRefreshing = false
            }
        }
    }

    private func loadMoreItems() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            items += Array(items.count..<items.count + 10)
            isLoading = false
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
