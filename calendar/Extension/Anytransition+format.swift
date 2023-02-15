//
//  Anytransition+format.swift
//  calendar
//
//  Created by 王峥 on 2023/2/13.
//

import SwiftUI

extension AnyTransition {
    static var testAction: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
            .combined(with: opacity)
        let removal = AnyTransition
            .slide
            .combined(with: opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

