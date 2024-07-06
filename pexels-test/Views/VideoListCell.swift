//
//  VideoListCell.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 04/07/24.
//

import SwiftUI

struct VideoListCell: View {
    let imageUrl: String
    let duration: Int
    let width: Int
    let height: Int
    let username: String

    @State private var image: UIImage?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
                    .clipped()
            } else {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
                    .onAppear {
                        loadImage()
                    }
            }

            Color.primaryBackground.opacity(0.15)
                .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)

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
        .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
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
