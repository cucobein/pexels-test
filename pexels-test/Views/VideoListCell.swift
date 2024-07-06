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
    }

    let imageUrl: String
    let duration: Int
    let width: Int
    let height: Int
    let username: String

    @State private var image: UIImage?

    private var thumbnail: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .clipped()
            } else {
                ProgressView()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private var overlay: some View {
        Color.primaryBackground.opacity(0.15)
            .frame(width: Constants.imageWidth, height: Constants.imageHeight)
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("\(width)x\(height)")
                .font(Font.montserratRegular.size(.caption))
                .foregroundColor(.primaryForeground)

            Text(duration.toDurationString())
                .font(Font.montserratRegular.size(.caption))
                .foregroundColor(.primaryForeground)
        }
        .padding(.horizontal, Padding.halfExtraSmall)
        .padding(.bottom, Padding.halfExtraSmall)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            thumbnail

            overlay

            info
        }
        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
    }

    private func loadImage() {
        if let cachedImage = CacheManager.shared.imageCache.object(forKey: NSString(string: imageUrl)) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: imageUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let downloadedImage = UIImage(data: data) {
                    CacheManager.shared.imageCache.setObject(downloadedImage, forKey: NSString(string: imageUrl))
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
    ZStack {
        Color.primaryBackground

        VideoListCell(
            imageUrl: "https://via.placeholder.com/150",
            duration: 150,
            width: 1_920,
            height: 1_080,
            username: "Hugo"
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .edgesIgnoringSafeArea(.all)
}
