//
//  Padding.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI

enum Padding: CGFloat {
    /// Size: 0
    case noPadding = 0
    /// Size: 4
    case halfExtraSmall = 4
    /// Size: 8
    case extraSmall = 8
    /// Size: 12
    case extraSmallPlus = 12
    /// Size: 16
    case small = 16
    /// Size: 24
    case medium = 24
    /// Size: 32
    case large = 32
    /// Size: 40
    case extraLarge = 40
    /// Size: 48
    case xxLarge = 48
    /// Size: 60
    case xxxLarge = 60
}

extension View {
    func padding(_ edges: Edge.Set = .all, _ padding: Padding) -> some View {
        self.padding(edges, padding.rawValue)
    }

    func padding(_ padding: Padding) -> some View {
        self.padding(padding.rawValue)
    }
}
