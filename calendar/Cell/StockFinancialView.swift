//
//  NewStockView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/14.
//

import SwiftUI

struct StockFinancialView: View {
    let info: NewStockInfo
    
    var body: some View {
        VStack(spacing: 5){
            DateView(chooseDay: info.id)
                //No Event status
            if info.possessData == 0 {
                StockStyleStack {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
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
                ForEach(info.stockList!, id: \.self) {
                    stockList in
                    StockStyleStack {
                        VStack {
                            TitleView(chooseType: stockList.first!.stockType)
                            ForEach(stockList) {
                                stock in
                                Stockview(stockItem: stock)
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

struct TitleView: View {
    let chooseType: Int
    
    var body: some View {
        HStack {
            //1.其他
            //2.休市提醒
            if chooseType == 3 {
                Image(systemName: "square.circle.fill")
                    .foregroundColor(.yellow)
                    .padding(.leading, 7)
                    .padding(.vertical, 15)
            } else {
                Image(systemName: "e.square")
                    .foregroundColor(.red)
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
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(.gray)
                    .padding([.horizontal], 30)
            }
        }
    }
}

struct Stockview:View {
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
                    Image(systemName: "calendar.badge.plus")
                        .foregroundColor(.gray)
    //                    .onTapGesture {
    //                        self.isShowingBottomView.toggle()
    //                    }
                    
                }.padding([.horizontal], 30)
                
                HStack(alignment: .bottom){
                    Text("发行价").font(.system(size: 15))
                    Text(String(stockItem.stockPrice!)).font(.system(size: 20, weight:.medium))
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
