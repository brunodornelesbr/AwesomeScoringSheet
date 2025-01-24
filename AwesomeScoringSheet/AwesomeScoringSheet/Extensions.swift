//
//  Extensions.swift
//  AwesomeScoringSheet
//
//  Created by Bruno on 22/01/25.
//

import SwiftUI
extension CGPoint {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}

extension View {
    func hideKeyboard () {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        guard self.indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
