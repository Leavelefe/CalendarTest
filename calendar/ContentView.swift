//
//  ContentView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CalendarView()
            Index()
        }
    }
}


/// Part of the logic and var retained in the CalendarView will be put into the Model and ViewModel respectively
struct CalendarView: View {
    var days: Array<String> = ["今", "02", "03", "04", "05", "06", "07"]
    var weeks: Array<String> = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    @State var dayOrMonth:Bool = true
    var body: some View {
        VStack {
            HStack {
                Text("2023年3月")
                Spacer()
                week
                Text("｜").padding(.horizontal, -10.0)
                month
            }
            .padding(.horizontal)
            LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem(), GridItem(), GridItem()]) {
                ForEach(weeks[0..<7], id: \.self) { weekday in
                    Text(weekday).font(.system(size: 10)).foregroundColor(.gray)
                }
                ForEach(days[0..<7], id: \.self) { day in
                    CircleView(content: day)
                }
            }
            .padding(.horizontal, 5.0)
        }
    }
    
    var week: some View {
        Button{ dayOrMonth = !dayOrMonth } label: { Text("周") }
    }
    var month: some View {
        Button{ dayOrMonth = !dayOrMonth } label: { Text("月") }
    }
}

/// Part of the logic and var retained in the CircleView will be put into the Model and ViewModel respectively
struct CircleView: View {
    @State var isChosen: Bool = false
    var content: String
    var body: some View {
        ZStack {
            let circleShape = Circle()
            
            if isChosen {
                circleShape.foregroundColor(.blue)
                Text(content)
                    .foregroundColor(.white)
            } else {
                circleShape.foregroundColor(.white)
                Text(content)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 7.0)
        .onTapGesture {
            isChosen = !isChosen
        }
    }
    
}

/// Part of the logic and var retained in the Index will be put into the Model and ViewModel respectively
struct Index:View {
    private let segmented = ["宏观财经","股票理财"]
    @State private var selector = 1
    var body: some View{
        VStack{
            HStack{
                ForEach(segmented, id: \.self) { name in
                    Button(action: {
                        if let index = segmented.firstIndex(of: name){
                            withAnimation {
                                selector = index
                            }
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
                    Image(systemName: "star")
                    Text("筛选")
                }.foregroundColor(.blue)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
            
    }
}
