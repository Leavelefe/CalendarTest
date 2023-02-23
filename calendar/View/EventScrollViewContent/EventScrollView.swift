//
//  EventScrollView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/23.
//

import SwiftUI

struct EventScrollView: View {
    @ObservedObject var viewModel: CalendarEventManager
    @State private var isLoading = false
    @State private var isRefreshing = false
    @State private var items = Array(0..<10)
    
    var body: some View {
        ScrollView {
            if viewModel.showEco {
                ForEach(viewModel.ecoInfos) { info in
                    EcnomicStaticView(info: info).transition(.empty)
                }
            } else {
                ForEach(viewModel.stockInfos) { info in
                    StockFinancialView(info: info).transition(.empty)
                }
            }
        }.refreshable {
            print("hohooh")
        }
    }
    
}

