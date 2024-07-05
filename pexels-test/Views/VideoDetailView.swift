//
//  VideoDetailView.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI
import AVKit
import UIKit

struct VideoDetailView: View {
    let videoUrl: String
    let username: String
    let width: Int
    let height: Int
    let duration: Int
    let quality: String
    let fileType: String
    let placeholderImageUrl: String

    @State private var player: AVPlayer?
    @State private var image: UIImage?

    // swiftlint:disable closure_body_length
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                        player.replaceCurrentItem(with: nil)
                    }
            } else {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            loadImage()
                        }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("@\(username)")
                    .font(.caption)
                    .foregroundColor(.white)
                Text("\(width)x\(height)")
                    .font(.caption)
                    .foregroundColor(.white)
                Text(duration.toDurationString())
                    .font(.caption)
                    .foregroundColor(.white)
                Text(quality)
                    .font(.caption)
                    .foregroundColor(.white)
                Text(fileType)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.black.opacity(0.5))
        }
        .onAppear {
            if let url = URL(string: videoUrl) {
                player = AVPlayer(url: url)
            }
        }
        .background(.black)
        .accessibilityIdentifier("VideoDetailView")
        .navigationBarTitle("Video Detail", displayMode: .inline)
    }

    private func loadImage() {
        if let cachedImage = CacheManager.shared.imageCache.object(forKey: NSString(string: placeholderImageUrl)) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: placeholderImageUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    let imageKey = NSString(string: placeholderImageUrl)
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

#Preview {
    VideoDetailView(
        videoUrl: "https://videos.pexels.com/video-files/3066463/3066463-uhd_4096_2160_24fps.mp4",
        username: "Hugo",
        width: 1_920,
        height: 1_080,
        duration: 150,
        quality: "HD",
        fileType: "mp4",
        placeholderImageUrl: "https://via.placeholder.com/150"
    )
}
