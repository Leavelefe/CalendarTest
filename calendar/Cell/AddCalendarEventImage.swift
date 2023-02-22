//
//  AddCalendarEventImage.swift
//  calendar
//
//  Created by 王峥 on 2023/2/21.
//

import SwiftUI

struct AddCalendarEventView: View {
    @Binding var showingConfirmationSheet: Bool
    @Binding var date: Date
    @Binding var textFieldString: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            NavigationStack {
                VStack(spacing: 0) {
                    HStack {
                        Button("取消") {
                            presentationMode.wrappedValue.dismiss()
                        }.padding()
                        Spacer()
                        Text("确认添加事件至系统日历")
                        Spacer()
                        Button("确认") {
                            presentationMode.wrappedValue.dismiss()
                        }.padding()
                    }
                    List {
                        TextField("", text: $textFieldString)
                        NavigationLink(destination: DateSelectionView(date: $date).navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("时间")
                                Spacer()
                                Text(date.getFullStringDate())
                                    .font(.system(size: 14))
                            }
                        }
                        //DatePicker(selection: $date, label: { Text("时间") })
                        NavigationLink(destination: RepeatSettingView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("重复")
                                Spacer()
                                Text("仅此一天")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        NavigationLink(destination: ReminderSettingView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("提醒")
                                Spacer()
                                Text("事件发生时")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }.listStyle(PlainListStyle())
                }
            }
        }.presentationDetents([.fraction(0.3)])
    }
}

struct AddCalendarEventSheet: ViewModifier {
    @State private var showingConfirmationSheet = false
    @State private var date: Date
    @State private var textFieldString: String

    let title: String
    let eventDay: Date

    init(title: String, eventDay: Date) {
        self.title = title
        self.eventDay = eventDay
        self._textFieldString = State(initialValue: title)
        self._date = State(initialValue: eventDay)
    }

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                self.showingConfirmationSheet = true
            }
            .sheet(isPresented: $showingConfirmationSheet) {
                AddCalendarEventView(showingConfirmationSheet: $showingConfirmationSheet, date: $date, textFieldString: $textFieldString)
            }
    }
}

extension View {
    func addCalendarEventSheet(title: String, date: Date) -> some View {
        self.modifier(AddCalendarEventSheet(title: title, eventDay: date))
    }
}

struct DateSelectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var date: Date
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Text("\(String(date.get(.year)))年")
                Spacer()
                Button("确认") {
                    presentationMode.wrappedValue.dismiss()
                }
            }.padding()
            Spacer()
            HStack {
                DatePicker(selection: $date, label: {})
            }
            Spacer()
        }
    }
}

struct RepeatSettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    enum Repeat: String, CaseIterable, Identifiable {
        case OnlyToday, EveryDay, EveryWeek, EveryMonth
        var id: Self { self }
    }

    @State private var selectedRepeat: Repeat = .OnlyToday
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Text("设置重复时间")
                Spacer()
                Button("确认") {
                    presentationMode.wrappedValue.dismiss()
                }
            }.padding()
            Spacer()
            HStack {
                Picker("Reapet", selection: $selectedRepeat) {
                    Text("仅此一天").tag(Repeat.OnlyToday)
                    Text("每日").tag(Repeat.EveryDay)
                    Text("每周").tag(Repeat.EveryWeek)
                    Text("每月").tag(Repeat.EveryMonth)
                }.pickerStyle(.inline)
            }
        }
    }
}

struct ReminderSettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    enum Reminder: String, CaseIterable, Identifiable {
        case WhenItHappend, FiveMinutesEarly, FifteenMinutesEarly, HarfHourEarly, OneHourEarly
        var id: Self { self }
    }

    @State private var selectedReminder: Reminder = .WhenItHappend
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Text("设置提醒时间")
                Spacer()
                Button("确认") {
                    presentationMode.wrappedValue.dismiss()
                }
            }.padding()
            Spacer()
            HStack {
                Picker("Reapet", selection: $selectedReminder) {
                    Text("事件发生时").tag(Reminder.WhenItHappend)
                    Text("5分钟前").tag(Reminder.FiveMinutesEarly)
                    Text("15分钟前").tag(Reminder.FifteenMinutesEarly)
                    Text("30分钟前").tag(Reminder.HarfHourEarly)
                    Text("1小时前").tag(Reminder.OneHourEarly)
                }.pickerStyle(.inline)
            }
        }
    }
}

struct AddCalendarEventImage_Previews: PreviewProvider {
    static var previews: some View {
        let item = NewEcoItem(id: "111", day: "20230221", title: "十三届全国人大常委会第三十九届会议", content: "十三届全国人大常委会第三十九届会议2月23日至24日在北京举行", infoType: 3)
        Image(systemName: "calendar.badge.plus")
            .foregroundColor(.gray)
            .padding(.trailing, 13)
            .padding(.leading, 0)
            .addCalendarEventSheet(title: "阿呀呀", date: Date())
    }
}
