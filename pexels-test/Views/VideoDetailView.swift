//
//  VideoDetailView.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 05/07/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    private enum Constants {
        static let infoPanelOpacity = 0.5
        static let bodyAccessibilityIdentifier = "VideoDetailView"
    }

    @StateObject var viewModel: VideoDetailViewModel

    private var player: some View {
        Group {
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                        player.replaceCurrentItem(with: nil)
                    }
            } else {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: Spacing.halfExtraSmall) {
            Text("@\(viewModel.username)")
                .font(Font.montserratBold.size(.subheading))
                .foregroundColor(.primaryForeground)

            HStack {
                Text("\(viewModel.width)x\(viewModel.height),")
                    .font(Font.montserratRegular.size(.caption))
                    .foregroundColor(.primaryForeground)

                Text(viewModel.quality + ",")
                    .font(Font.montserratRegular.size(.caption))
                    .foregroundColor(.primaryForeground)

                Text(viewModel.fileType + ",")
                    .font(Font.montserratRegular.size(.caption))
                    .foregroundColor(.primaryForeground)

                Text(viewModel.duration.toDurationString())
                    .font(Font.montserratRegular.size(.caption))
                    .foregroundColor(.primaryForeground)
            }
        }
        .padding([.leading, .bottom], Padding.extraSmall)
        .background(.primaryBackground.opacity(Constants.infoPanelOpacity))
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            player

            info
        }
        .background(.primaryBackground)
        .accessibilityIdentifier(Constants.bodyAccessibilityIdentifier)
    }
}

#Preview {
    NavigationView {
        VideoDetailView(
            viewModel: VideoDetailViewModel(
                videoUrl: "https://videos.pexels.com/video-files/3066463/3066463-uhd_4096_2160_24fps.mp4",
                username: "Hugo",
                width: 1_920,
                height: 1_080,
                duration: 150,
                quality: "HD",
                fileType: "mp4",
                placeholderImageUrl: "https://via.placeholder.com/150"
            )
        )
    }
}
