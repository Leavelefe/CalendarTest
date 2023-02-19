//
//  FilterButton.swift
//  calendar
//
//  Created by 王峥 on 2023/2/19.
//

import SwiftUI

struct FilterButton: View {
    @State var selected: Bool
    let content: String
    
    var body: some View {
        if selected {
            Button(content) {
                selected.toggle()
            }
            .frame(width: 80, height: 30)
            .font(.system(size: 15))
            .border(Color.gray, width: 0.3)
            .background(Color.blue)
            .foregroundColor(.white)
        } else {
            Button(content) {
                selected.toggle()
            }
            .frame(width: 80, height: 30)
            .font(.system(size: 15))
            .border(Color.gray, width: 0.3)
            .background(Color.white)
            .foregroundColor(.gray)
        }
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton(selected: true, content: "hhi")
    }
}
