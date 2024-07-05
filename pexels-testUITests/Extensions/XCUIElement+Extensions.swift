//
//  XCUIElement+Extensions.swift
//  pexels-testUITests
//
//  Created by Hugo Ramirez on 04/07/24.
//

import XCTest

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }

        self.tap()

        let deleteString = stringValue.map { _ in "\u{8}" }.joined(separator: "")
        self.typeText(deleteString)
    }
}
