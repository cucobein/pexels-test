//
//  VideoDetailViewModel.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI
import AVKit
import Combine

class VideoDetailViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var image: UIImage?

    let videoUrl: String
    let username: String
    let width: Int
    let height: Int
    let duration: Int
    let quality: String
    let fileType: String
    let placeholderImageUrl: String

    init(
        videoUrl: String,
        username: String,
        width: Int,
        height: Int,
        duration: Int,
        quality: String,
        fileType: String,
        placeholderImageUrl: String
    ) {
        self.videoUrl = videoUrl
        self.username = username
        self.width = width
        self.height = height
        self.duration = duration
        self.quality = quality
        self.fileType = fileType
        self.placeholderImageUrl = placeholderImageUrl
        loadVideo()
    }

    private func loadVideo() {
        if let url = URL(string: videoUrl) {
            player = AVPlayer(url: url)
        } else {
            loadImage()
        }
    }

    private func loadImage() {
        if let cachedImage = CacheManager.shared.imageCache.object(forKey: NSString(string: placeholderImageUrl)) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: placeholderImageUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    let imageKey = NSString(string: self.placeholderImageUrl)
                    CacheManager.shared.imageCache.setObject(downloadedImage, forKey: imageKey)
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                    }
                }
            }
            .resume()
        }
    }
}
