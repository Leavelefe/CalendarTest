//
//  AddCalendarEventImage.swift
//  calendar
//
//  Created by 王峥 on 2023/2/21.
//

import SwiftUI

struct AddCalendarEventView: View {
    let eventDay: Date
    let eventType: Int
    let key: String
    @Binding var showingConfirmationSheet: Bool
    @Binding var textFieldString: String
    
    @State var selectedDate: Date
    @State var repeatType: Repeat = .OnlyToday
    @State var reminderType: Reminder = .WhenItHappend
    @ObservedObject var viewModel: CalendarDataViewModel
    //@State var chooseNewDate: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack(spacing: 0) {
                    HStack {
                        Button("取消") {
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }.padding()
                        Spacer()
                        Text("确认添加事件至系统日历")
                        Spacer()
                        Button("确认") {
                            withAnimation {
                                viewModel.saveEventByKey(set: CustomizedCalendarEvent(title: textFieldString, date: selectedDate, eventType: eventType, repeatType: repeatType, reminderType: reminderType, id: key), byKey: key)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }.padding()
                    }
                    List {
                        TextField("事件名称，不超过21个字符", text: $textFieldString)
                        NavigationLink(destination: DateSelectionView(date: $selectedDate, eventDay: eventDay).navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("时间")
                                Spacer()
                                Text(selectedDate.getFullStringDate())
                                    .font(.system(size: 14))
                            }
                        }
                        //DatePicker(selection: $date, label: { Text("时间") })
                        NavigationLink(destination: RepeatSettingView(selectedRepeat: $repeatType).navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("重复")
                                Spacer()
                                Text(getRelatedRepeatText(repeatType))
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        NavigationLink(destination: ReminderSettingView(selectedReminder: $reminderType).navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("提醒")
                                Spacer()
                                Text(getRelatedReminderText(reminderType))
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
    @ObservedObject var viewModel: CalendarDataViewModel
    
    private let cusomizedEvent: CustomizedCalendarEvent
    let title: String
    let eventDay: Date

    init(cusomizedEvent: CustomizedCalendarEvent, viewModel: CalendarDataViewModel) {
        self.viewModel = viewModel
        self.cusomizedEvent = cusomizedEvent
        self.title = cusomizedEvent.title
        self.eventDay = cusomizedEvent.date
        self._textFieldString = State(initialValue: title)
        self._date = State(initialValue: eventDay)
    }

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                self.showingConfirmationSheet = true
            }
            .sheet(isPresented: $showingConfirmationSheet) {
                AddCalendarEventView(eventDay: date, eventType: cusomizedEvent.eventType, key: cusomizedEvent.id, showingConfirmationSheet: $showingConfirmationSheet, textFieldString: $textFieldString, selectedDate: date, repeatType: cusomizedEvent.repeatType, reminderType: cusomizedEvent.reminderType, viewModel: viewModel)
            }
    }
}

extension View {
    func addCalendarEventSheet(cusomizedEvent: CustomizedCalendarEvent, viewModel: CalendarDataViewModel) -> some View {
        self.modifier(AddCalendarEventSheet(cusomizedEvent: cusomizedEvent, viewModel: viewModel))
    }
}

struct DateSelectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var date: Date
    //@Binding var chooseNewDate: Bool
    
    let eventDay: Date
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    date = eventDay
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

    @Binding var selectedRepeat: Repeat
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    selectedRepeat = .OnlyToday
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

    @Binding var selectedReminder: Reminder
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    selectedReminder = .WhenItHappend
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

        Image(systemName: "calendar.badge.plus")
            .foregroundColor(.gray)
            .padding(.trailing, 13)
            .padding(.leading, 0)
            .addCalendarEventSheet(cusomizedEvent: CustomizedCalendarEvent(title: "Meeting", date: Date(), eventType: 3, repeatType: .EveryMonth, reminderType: .FifteenMinutesEarly, id: "1232"), viewModel: CalendarDataViewModel())
    }
}


