//
//  EventTabView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/20.
//

import SwiftUI

/// Part of the logic and var retained in the Index will be put into the Model and ViewModel respectively
struct EventTabView: View {
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
                            viewModel.switchTab(index)
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
                                ForEach(viewModel.filterContent, id: \.title) {
                                    tuple in
                                    FilterButton(viewModel: viewModel, content: tuple.title, selected: tuple.selected)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                    }.padding(.top, -10)
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 1.0))
        .shadow(radius: 1, x: 0, y: 0)
    }
}
