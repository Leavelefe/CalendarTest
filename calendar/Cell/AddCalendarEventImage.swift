//
//  AddCalendarEventImage.swift
//  calendar
//
//  Created by 王峥 on 2023/2/21.
//

import SwiftUI

struct AddCalendarEventImage: View {
    let item: NewEcoItem
    @State private var showingConfirmationSheet = false
    @State private var date: Date?
    @State private var textFieldString: String
        
    init(item: NewEcoItem) {
        self.item = item
        self._textFieldString = State(initialValue: item.title)
    }
    
    var body: some View {
        Image(systemName: "calendar.badge.plus")
            .foregroundColor(.gray)
            .padding(.trailing, 13)
            .padding(.leading, 0)
            .onTapGesture {
                showingConfirmationSheet = true
                date = Date()
            }
            .sheet(isPresented: $showingConfirmationSheet) {
                VStack {
                    VStack(spacing: 0){
                        HStack {
                            Button("取消") {
                                
                            }.padding()
                            Spacer()
                            Text("确认添加事件至系统日历")
                            Spacer()
                            Button("确认") {
                                
                            }.padding()
                        }
                        List{
                            TextField("", text: $textFieldString)
                            DatePicker(selection: .constant(Date()), label: { Text("时间") })
                            Text("重复")
                            Text("提醒")
                        }.listStyle(PlainListStyle())
                    }
                }.presentationDetents([.fraction(0.3)])
                    
            }
    }
}

struct AddCalendarEventImage_Previews: PreviewProvider {
    static var previews: some View {
        let item = NewEcoItem(id: "111", day: "20230221", title: "十三届全国人大常委会第三十九届会议", content: "十三届全国人大常委会第三十九届会议2月23日至24日在北京举行", infoType: 3)
        AddCalendarEventImage(item: item)
    }
}
