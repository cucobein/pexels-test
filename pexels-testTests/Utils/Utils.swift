//
//  Utils.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation

class Utils {
    static func loadJSONFromFile(_ name: String) -> Data? {
        let bundle = Bundle(for: PexelsServiceTests.self)
        let url = bundle.url(forResource: name, withExtension: "json")!
        return try? Data(contentsOf: url)
    }
}
