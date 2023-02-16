//
//  Anytransition+format.swift
//  calendar
//
//  Created by 王峥 on 2023/2/13.
//

import SwiftUI

extension AnyTransition {
    static var testAction: AnyTransition {
        let insertion = AnyTransition.move(edge: .top)
        let removal = AnyTransition
            .move(edge: .top)
            .combined(with: opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

