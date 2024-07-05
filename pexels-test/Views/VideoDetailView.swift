//
//  VideoDetailView.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    let video: Video
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
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
                Text("Loading video...")
            }

            Text("@\(video.user.name)")
                .font(.headline)
                .padding()

            Text("\(video.width)x\(video.height)")
                .font(.subheadline)
                .padding()

            Text("\(video.duration.toDurationString())")
                .font(.subheadline)
                .padding()
        }
        .onAppear {
            loadVideo()
        }
        .accessibilityIdentifier("VideoDetailView")
        .navigationBarTitle("Video Detail", displayMode: .inline)
    }

    private func loadVideo() {
        if let videoURL = URL(string: video.videoFiles.first?.link ?? "") {
            let cacheKey = NSString(string: videoURL.absoluteString)
            if let cachedItem = CacheManager.shared.videoCache.object(forKey: cacheKey) {
                player = AVPlayer(playerItem: cachedItem)
            } else {
                let playerItem = AVPlayerItem(url: videoURL)
                CacheManager.shared.videoCache.setObject(playerItem, forKey: cacheKey)
                player = AVPlayer(playerItem: playerItem)
            }
        }
    }
}
#Preview {
    VideoDetailView(
        video: Video(
            id: 1,
            width: 1_920,
            height: 1_080,
            url: "https://via.placeholder.com/150",
            image: "https://via.placeholder.com/150",
            duration: 150,
            user: User(id: 1, name: "Hugo", url: "https://via.placeholder.com/150"),
            videoFiles: [
                VideoFile(
                    id: 1_448_735,
                    quality: "HD",
                    fileType: "mp4",
                    width: 1_920,
                    height: 1_080,
                    link: "https://videos.pexels.com/video-files/3066463/3066463-uhd_4096_2160_24fps.mp4"
                )
            ],
            videoPictures: []
        )
    )
}
