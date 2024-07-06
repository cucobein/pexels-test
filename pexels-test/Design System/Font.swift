//
//  PexelsFontModifier.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI

enum FontSize {
    /// Size: 36
    case titleXLarge
    /// Size: 28
    case titleLarge
    /// Size: 24
    case title
    /// Size: 20
    case largeBody
    /// Size: 18
    case heading
    /// Size: 16
    case subheading
    /// Size: 14
    case body
    /// Size: 12
    case caption
    /// Custom size
    case custom(size: CGFloat)

    var size: CGFloat {
        switch self {
        case .titleXLarge: 36
        case .titleLarge: 28
        case .title: 24
        case .largeBody: 20
        case .heading: 18
        case .subheading: 16
        case .body: 14
        case .caption: 12
        case .custom(let size): size
        }
    }
}

enum Font {
    case montserratRegular
    case montserratBold
    case bebasNeueRegular

    var name: String {
        switch self {
        case .montserratRegular: return "Montserrat-Regular"
        case .montserratBold: return "Montserrat-Bold"
        case .bebasNeueRegular: return "BebasNeue-Regular"
        }
    }

    func size(_ fontSize: FontSize) -> SwiftUI.Font {
        SwiftUI.Font.custom(self.name, size: fontSize.size)
    }
}
