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
                    .accessibilityIdentifier("VideoPlayer")
            } else {
                Text("Loading video...")
                    .accessibilityIdentifier("LoadingText")
            }

            Text("@\(video.user.name)")
                .font(.headline)
                .padding()
                .accessibilityIdentifier("VideoUserName")

            Text("\(video.width)x\(video.height)")
                .font(.subheadline)
                .padding()
                .accessibilityIdentifier("VideoResolution")

            Text("\(video.duration.toDurationString())")
                .font(.subheadline)
                .padding()
                .accessibilityIdentifier("VideoDuration")
        }
        .onAppear {
            if let videoURL = URL(string: video.videoFiles.first?.link ?? "") {
                player = AVPlayer(url: videoURL)
            }
        }
        .accessibilityIdentifier("VideoDetailView")
        .navigationBarTitle("Video Detail", displayMode: .inline)
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
