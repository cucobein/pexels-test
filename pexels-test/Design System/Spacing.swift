//
//  Spacing.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI

enum Spacing: CGFloat {
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

extension VStack {
    init(spacing: Spacing, @ViewBuilder content: () -> Content) {
        self.init(spacing: spacing.rawValue, content: content)
    }

    init(
        alignment: HorizontalAlignment = .center,
        spacing: Spacing? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(alignment: alignment, spacing: spacing?.rawValue, content: content)
    }
}

extension LazyVGrid {
    init(columns: [GridItem], spacing: Spacing? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.init(columns: columns, spacing: spacing?.rawValue, content: content)
    }
}
