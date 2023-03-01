//
//  NewStockView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/14.
//

import SwiftUI

struct StockFinancialView: View {
    let info: NewStockInfo
    @ObservedObject var dataViewModel: CalendarDataViewModel
    
    var body: some View {
        VStack(spacing: 5){
            DateView(chooseDay: info.id)
                //No Event status
                //No stock data && No customized events
            if info.possessData == 0 && !dataViewModel.haveCustomizedDataInThatDay(dateID: info.id.getStringID()) {
                StockStyleStack {
                    VStack {
                        Spacer()
                        HStack {
                            Image("calendar_today_nodata")
                                .resizable()
                                .frame(width: 100, height: 70)
                                .foregroundColor(.blue)
                                //When eventType = 3, change id inside addCalendarEventSheet
                                .addCalendarEventSheet(cusomizedEvent: dataViewModel.generateEventBufferData(title: "", date: info.id, eventType: 3, id: nil), viewModel: dataViewModel)
                        }
                        HStack {
                            Spacer()
                            Image("calendar_add_event")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .foregroundColor(.blue)
                            
                            Text("您可以添加事件").font(.system(size: 13))
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        Spacer()
                    }.frame(height: 150)
                }
                
            } else {
                if dataViewModel.haveCustomizedDataInThatDay(dateID: info.id.getStringID()) {
                    StockStyleStack {
                        VStack {
                            CustomizedEventTitleView()
                            ForEach(dataViewModel.returnCustomizedDataEvents(dateID: info.id.getStringID()), id: \.id) {
                                customizedDataEvent in
                                CustomizedEventContentView(dataViewModel: dataViewModel, customizedEvent: customizedDataEvent)
                            }
                        }
                    }
                }
                
                ForEach(info.stockList!, id: \.self) {
                    stockList in
                    StockStyleStack {
                        VStack {
                            TitleView(dataViewModel: dataViewModel, stockItem: stockList[0], chooseType: stockList.first!.stockType)
                            ForEach(stockList) {
                                stock in
                                Stockview(dataViewModel: dataViewModel, stockItem: stock)
                            }
                        }
                    }
                }
            }
        }
    }
}


struct DateView: View {
    let chooseDay: Date
    
    var body: some View {
        if myCalendar.isSameDay(is: chooseDay, equalto: Date()) {
            HStack {
                HStack (spacing: 0){
                    Text("今日待办").font(.system(size: 24, weight: .light))
                }
                Spacer()
            }.padding(.horizontal)
            
        } else {
            HStack {
                HStack (spacing: 0){
                    Text(String(chooseDay.get(.day))).font(.system(size: 20, weight: .medium))
                    Text("｜").font(.system(size: 15, weight:.light))
                    Text(String(chooseDay.get(.month))).font(.system(size: 13, weight:.light))
                    Text(chooseDay.getWeekDay()).font(.system(size: 13, weight:.light))
                }
                Spacer()
            }.padding(.horizontal)
        }
    }
}

struct CustomizedEventTitleView: View {
    var body: some View {
        HStack {
            Image("mine_calendar_event")
                .padding(.leading, 7)
                .padding(.vertical, 15)
            
            Text("我创建的事件").font(.system(size: 15))
            Spacer()
        }
    }
}

struct CustomizedEventContentView: View {
    @ObservedObject var dataViewModel: CalendarDataViewModel
    let customizedEvent: CustomizedCalendarEvent
    
    var body: some View {
        VStack {
            HStack {
                Text(customizedEvent.title)
                Spacer()
            }.padding([.horizontal], 30)
                .padding(.top, -15)
                .padding(.bottom, 10)
                .addCalendarEventSheet(cusomizedEvent: customizedEvent, viewModel: dataViewModel)
            Divider()
        }
    }
}

struct TitleView: View {
    @ObservedObject var dataViewModel: CalendarDataViewModel
    let stockItem: NewStockItem
    let chooseType: Int
    
    var body: some View {
        HStack {
            //1.其他
            //2.休市提醒
            if chooseType == 3 {
                Image("calendar_closedmarket")
                    .padding(.leading, 7)
                    .padding(.vertical, 15)
            } else {
                Image("mine_calendar_stock")
                    .padding(.leading, 7)
                    .padding(.vertical, 15)
            }
            //1. 新股新债
            //2. 休市提醒 3
            if chooseType == 3 {
                Text("休市提醒").font(.system(size: 15))
            } else {
                Text("新股新债").font(.system(size: 15))
            }
            
            //1. 首发上市 1/4
            //2. 申购 2/5
            //3. 无
            if chooseType == 1 || chooseType == 4 {
                ZStack {
                    Rectangle().strokeBorder(.orange).frame(width: 55, height: 20)
                    Text("首发上市").font(.system(size: 13, weight:.light))
                }.foregroundColor(.orange)
            } else if chooseType == 2 || chooseType == 5 {
                ZStack {
                    Rectangle().strokeBorder(.orange).frame(width: 30, height: 20)
                    Text("申购").font(.system(size: 13, weight:.light))
                }.foregroundColor(.orange)
            }
            Spacer()
            
            if chooseType == 3 {
                if let existingCalendarEvent = dataViewModel.events.first(where: { $0.id == stockItem.id }) {
                    Image("calendar_icon_add_event_success")
                        .padding([.horizontal], 15)
                        .addCalendarEventSheet(cusomizedEvent: existingCalendarEvent, viewModel: dataViewModel)
                } else {
                    Image("calendar_icon_add_event")
                        .padding([.horizontal], 15)
                        .addCalendarEventSheet(cusomizedEvent: dataViewModel.generateEventBufferData(title: stockItem.getTitle(), date: stockItem.getDate(), eventType: 1, id: stockItem.id), viewModel: dataViewModel)
                }
            }
        }
    }
}

struct Stockview:View {
    @ObservedObject var dataViewModel: CalendarDataViewModel
    let stockItem: NewStockItem
    
    var body: some View {
        if stockItem.stockType == 3 {
            HStack{
                Text("A股休市；港股通暂停交易")
                Spacer()
            }.padding([.horizontal], 30)
            .padding(.top, -15)
            .padding(.bottom, 10)
        } else {
            VStack {
                HStack {
                    //Stock Title
                    Text(stockItem.stockName!).font(.system(size: 17, weight:.medium))
                    //Stock ID
                    Text(stockItem.id!).font(.system(size: 17, weight:.medium))
                    //1.新股
                    //2.新债
                    //3.无
                    Text("・新股").font(.system(size: 13, weight:.light))
                        .foregroundColor(.orange)
                    Spacer()
                    if let existingCalendarEvent = dataViewModel.events.first(where: { $0.id == stockItem.id }) {
                        Image("calendar_icon_add_event_success")
                            .padding(.trailing, -20)
                            .addCalendarEventSheet(cusomizedEvent: existingCalendarEvent, viewModel: dataViewModel)
                    } else {
                        Image("calendar_icon_add_event")
                            .padding(.trailing, -20)
                            .addCalendarEventSheet(cusomizedEvent: dataViewModel.generateEventBufferData(title: stockItem.getTitle(), date: stockItem.getDate(), eventType: 1, id: stockItem.id), viewModel: dataViewModel)
                    }
                    
                }.padding([.horizontal], 30)
                
                HStack(alignment: .bottom){
                    Text("发行价").font(.system(size: 15))
                    Text(stockItem.stockPrice!).font(.system(size: 20, weight:.medium))
                        .foregroundColor(.red)
                    Text("元").font(.system(size: 15))
                    Spacer()
                }.padding(.top, -5)
                .padding(.leading, 30)
                .padding(.bottom, 5)

            }
            
        }
    }
}



struct StockStyleStack<Content>: View where Content: View {
    let content: () -> Content
        
    var body: some View {
        AnyView(content()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .shadow(radius: 1, x: 0, y: 0)
            .padding(.horizontal)
            .padding(.bottom)
        )
    }
}



class BottomViewController: UIViewController {
    let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.backgroundColor = .blue
        view.addSubview(bottomView)
    }
}

struct BottomViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BottomViewController {
        let controller = BottomViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: BottomViewController, context: Context) {
    }
    
    typealias UIViewControllerType = BottomViewController
}
