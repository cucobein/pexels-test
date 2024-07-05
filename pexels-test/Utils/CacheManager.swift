//
//  CacheManager.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import Foundation
import UIKit
import AVFoundation

class CacheManager {
    static let shared = CacheManager()
    private init() {}

    let imageCache = NSCache<NSString, UIImage>()
    let videoCache = NSCache<NSString, AVPlayerItem>()
}
