//
//  CalendarWeekListView.swift
//  calendar
//
//  Created by 王峥 on 2023/2/15.
//

import SwiftUI

struct CalendarWeekListView<Item, ItemView>: View where ItemView : View, Item : Identifiable {
    var items: [Item]
    var content: (Item) -> ItemView
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 30), spacing: 0), count: 7), spacing: 0) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
}

//struct CalendarWeekListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarWeekListView()
//    }
//}
