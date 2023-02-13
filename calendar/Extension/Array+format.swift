//
//  Array+format.swift
//  calendar
//
//  Created by 王峥 on 2023/2/13.
//

import Foundation

extension Array {
    var oneAndOneOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
