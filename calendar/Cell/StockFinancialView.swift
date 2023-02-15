//
//  NewStockView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/14.
//

import SwiftUI

struct StockFinancialView: View {
    var body: some View {
        VStack {
            TitleView()
            Stockview()
        }
    }
}

struct TitleView: View {
    var body: some View {
        HStack {
            Image(systemName: "e.square")
                .foregroundColor(.red)
            Text("TestData")
            ZStack {
                Rectangle().strokeBorder(.red).frame(width: 40, height: 30, alignment: .trailing)
                Text("申购")
            }.foregroundColor(.red)
            Spacer()
        }
    }
}

struct Stockview:View {
    var body: some View {
        VStack {
            HStack {
                //Stock Title
                Text("中润申购")
                //Stock ID
                Text("123456")
                ZStack {
                    Text("新股")
                }.foregroundColor(.red)
                Spacer()
            }.padding([.horizontal], 30)
            
            HStack{
                Text("发行价 100元")
                Spacer()
            }.padding([.horizontal, .top], 30)

        }
    }
}

struct StockFinancialView_Previews: PreviewProvider {
    static var previews: some View {
        StockFinancialView()
    }
}
