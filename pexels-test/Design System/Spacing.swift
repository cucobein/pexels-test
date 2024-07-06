//
//  Spacing.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import Foundation

enum Spacing: CGFloat {
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

    /// Size: 8
    static var extraSmallValue: CGFloat { Spacing.extraSmall.rawValue }
    /// Size: 12
    static var extraSmallPlusValue: CGFloat { Spacing.extraSmallPlus.rawValue }
    /// Size: 16
    static var smallValue: CGFloat { Spacing.small.rawValue }
    /// Size: 24
    static var mediumValue: CGFloat { Spacing.medium.rawValue }
    /// Size: 32
    static var largeValue: CGFloat { Spacing.large.rawValue }
    /// Size: 40
    static var extraLargeValue: CGFloat { Spacing.extraLarge.rawValue }
    /// Size: 48
    static var xxLargeValue: CGFloat { Spacing.xxLarge.rawValue }
    /// Size: 60
    static var xxxLargeValue: CGFloat { Spacing.xxxLarge.rawValue }
}
