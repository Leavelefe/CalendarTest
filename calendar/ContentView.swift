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
    @State private var offset: CGFloat = 0
    
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
                    }.animation(nil)
                    
            }
            .onSwipe{ direction in
                withAnimation {
                    viewModel.swipeMonthOrWeek(direction)
                }
            }
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
            withAnimation {
                viewModel.swithMode(.Month)
            }
        }){
            Text("月")
                .foregroundColor(viewModel.mode == .Week ? .gray : .black)
        }
    }
}


struct EventScrollView: View {
    @ObservedObject var viewModel: CalendarEventManager
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var items = Array(0..<10)
    
    var body: some View {
        ScrollView {
            if viewModel.showEco {
                ForEach(viewModel.ecoInfos) { info in
                    EcnomicStaticView(info: info).onDisappear(perform: {print("dsad")})
                }
            } else {
                ForEach(viewModel.stockInfos) { info in
                    StockFinancialView(info: info)
                }
            }
        }.refreshable {
            print("hohooh")
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
