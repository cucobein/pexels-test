//
//  VideoListCellViewModel.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI
import Combine

class VideoListCellViewModel: ObservableObject {
    @Published var image: UIImage?

    let imageUrl: String
    let duration: Int
    let width: Int
    let height: Int
    let username: String

    init(imageUrl: String, duration: Int, width: Int, height: Int, username: String) {
        self.imageUrl = imageUrl
        self.duration = duration
        self.width = width
        self.height = height
        self.username = username
        loadImage()
    }

    private func loadImage() {
        if let cachedImage = CacheManager.shared.imageCache.object(forKey: NSString(string: imageUrl)) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: imageUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    CacheManager.shared.imageCache.setObject(downloadedImage, forKey: NSString(string: self.imageUrl))
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                    }
                }
            }
            .resume()
        }
    }
}
