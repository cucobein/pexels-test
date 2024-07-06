//
//  VideoListCell.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 04/07/24.
//

import SwiftUI

struct VideoListCell: View {
    private enum Constants {
        static let imageWidth: CGFloat = UIScreen.main.bounds.width / 3 - 1
        static let imageHeight: CGFloat = UIScreen.main.bounds.width / 3 - 1
        static let overlayOpacity = 0.15
    }

    @StateObject var viewModel: VideoListCellViewModel

    private var thumbnail: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .clipped()
            } else {
                ProgressView()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
            }
        }
    }

    private var overlay: some View {
        Color.primaryBackground.opacity(Constants.overlayOpacity)
            .frame(width: Constants.imageWidth, height: Constants.imageHeight)
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: Spacing.halfExtraSmall) {
            Text("\(viewModel.width)x\(viewModel.height)")
                .font(Font.montserratRegular.size(.caption))
                .foregroundColor(.primaryForeground)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .halfExtraSmall)
                .padding(.horizontal, .halfExtraSmall)

            Text(viewModel.duration.toDurationString())
                .font(Font.montserratRegular.size(.caption))
                .foregroundColor(.primaryForeground)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, .halfExtraSmall)
                .padding(.bottom, .halfExtraSmall)
        }
        .frame(maxWidth: .infinity)
        .background(.primaryBackground)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.primaryBackground

            thumbnail

            overlay

            info
        }
        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
    }
}

#Preview {
    ZStack {
        Color.primaryBackground

        VideoListCell(
            viewModel: VideoListCellViewModel(
                imageUrl: "https://via.placeholder.com/150",
                duration: 150,
                width: 1_920,
                height: 1_080,
                username: "Hugo"
            )
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .edgesIgnoringSafeArea(.all)
}
