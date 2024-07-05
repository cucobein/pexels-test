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

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.black

            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
            }

            Color.black.opacity(0.15)
                .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)

            VStack(alignment: .leading, spacing: .zero) {
                Text("\(width)x\(height)")
                    .font(.caption)
                    .foregroundColor(.white)
                Text(duration.toDurationString())
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .frame(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
    }
}

#Preview {
    VideoListCell(
        imageUrl: "https://via.placeholder.com/150",
        duration: 150,
        width: 1_920,
        height: 1_080,
        username: "Hugo"
    )
    .frame(width: 150)
}
