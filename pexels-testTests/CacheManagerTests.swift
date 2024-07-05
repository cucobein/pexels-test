//
//  CacheManagerTests.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 05/07/24.
//

import XCTest
import AVFoundation
@testable import pexels_test

class CacheManagerTests: XCTestCase {
    func testImageCaching() {
        let cache = CacheManager.shared.imageCache
        let imageUrl = "https://images.pexels.com/videos/8856785/pexels-photo-8856785.jpeg"
        let image = UIImage()

        cache.setObject(image, forKey: NSString(string: imageUrl))

        let cachedImage = cache.object(forKey: NSString(string: imageUrl))

        XCTAssertNotNil(cachedImage, "Image should be cached")
        XCTAssertEqual(image, cachedImage, "Cached image should match the original image")
    }

    func testVideoCaching() {
        let cache = CacheManager.shared.videoCache
        let videoUrl = "https://videos.pexels.com/video-files/3066463/3066463-uhd_4096_2160_24fps.mp4"
        let playerItem = AVPlayerItem(url: URL(string: videoUrl)!)

        cache.setObject(playerItem, forKey: NSString(string: videoUrl))

        let cachedVideo = cache.object(forKey: NSString(string: videoUrl))

        XCTAssertNotNil(cachedVideo, "Video should be cached")
        XCTAssertEqual(playerItem, cachedVideo, "Cached video should match the original video")
    }
}
