//
//  Int+Extensions.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 04/07/24.
//

import Foundation

extension Int {
    func toDurationString() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: minutes > 9 ? "%d:%02d" : "%d:%02d", minutes, seconds)
    }
}
