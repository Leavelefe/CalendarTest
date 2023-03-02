//
//  EventScrollView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/23.
//

import SwiftUI

/// 事件滚动视图
struct EventScrollView: View {
    @ObservedObject var viewModel: CalendarEventManager
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var items = Array(0..<10)
    @Binding var cancelSwipeAnimation: Int
    
    @StateObject var dataViewModel = CalendarDataViewModel()
    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.showEco {
                    ForEach(viewModel.ecoInfos) { info in
                        EcnomicStaticView(info: info, dataViewModel: dataViewModel).transition(.empty)
                    }.animation(nil, value: cancelSwipeAnimation)
                } else {
                    ForEach(viewModel.stockInfos) { info in
                        StockFinancialView(info: info, dataViewModel: dataViewModel).transition(.empty)
                    }.animation(nil, value: cancelSwipeAnimation)
                }
            }//.animation(nil, value: cancelSwipeAnimation)
            .refreshable {
                print("hohooh")
            }
            if !viewModel.showEco {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("calendar_add")
                            .padding(.trailing, 20)
                            .addCalendarEventSheet(cusomizedEvent: dataViewModel.generateEventBufferData(title: "", date: Date(), eventType: 3, id: nil), viewModel: dataViewModel)
                    }.padding(.bottom, 40)
                }
            }
        }
    }
    
}

