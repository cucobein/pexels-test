//
//  Video.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation

// swiftlint:disable identifier_name
struct Video: Codable, Identifiable, Equatable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let image: String
    let duration: Int
    let user: User
    let videoFiles: [VideoFile]
    let videoPictures: [VideoPicture]

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, image, duration, user
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }

    static func == (lhs: Video, rhs: Video) -> Bool {
        lhs.id == rhs.id &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.url == rhs.url &&
        lhs.image == rhs.image &&
        lhs.duration == rhs.duration &&
        lhs.user == rhs.user &&
        lhs.videoFiles == rhs.videoFiles &&
        lhs.videoPictures == rhs.videoPictures
    }
}

struct User: Codable, Equatable {
    let id: Int
    let name: String
    let url: String

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.url == rhs.url
    }
}

struct VideoFile: Codable, Equatable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int?
    let height: Int?
    let link: String

    enum CodingKeys: String, CodingKey {
        case id, quality
        case fileType = "file_type"
        case width, height, link
    }

    static func == (lhs: VideoFile, rhs: VideoFile) -> Bool {
        lhs.id == rhs.id &&
        lhs.quality == rhs.quality &&
        lhs.fileType == rhs.fileType &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.link == rhs.link
    }
}

struct VideoPicture: Codable, Equatable {
    let id: Int
    let picture: String
    let nr: Int

    static func == (lhs: VideoPicture, rhs: VideoPicture) -> Bool {
        lhs.id == rhs.id &&
        lhs.picture == rhs.picture &&
        lhs.nr == rhs.nr
    }
}

struct VideoResponse: Codable {
    let page: Int
    let perPage: Int
    let totalResults: Int
    let url: String
    let videos: [Video]

    enum CodingKeys: String, CodingKey {
        case page, perPage = "per_page", totalResults = "total_results", url, videos
    }
}
