//
//  MockVideoRepository.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation
@testable import pexels_test

class MockVideoRepository: VideoRepositoryProtocol {
    var videos: [VideoObject] = []
    var shouldThrowErrorOnSave = false

    func save(videos: [Video], searchTerm: String) throws {
        if shouldThrowErrorOnSave {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Simulated save error"])
        }
        self.videos = videos.map { video in
            let videoObject = initializeVideoObject(video: video, searchTerm: searchTerm)
            print("Saving video with searchTerm: \(searchTerm)")
            return videoObject
        }
    }

    func fetchVideos(for searchTerm: String) -> [VideoObject] {
        let fetchedVideos = videos.filter { $0.searchTerm == searchTerm }
        print("Fetching videos with searchTerm: \(searchTerm), found: \(fetchedVideos.count)")
        return fetchedVideos
    }

    private func initializeVideoObject(video: Video, searchTerm: String) -> VideoObject {
        let videoObject = VideoObject()
        videoObject.id = video.id
        videoObject.width = video.width
        videoObject.height = video.height
        videoObject.url = video.url
        videoObject.image = video.image
        videoObject.duration = video.duration
        videoObject.userName = video.user.name
        videoObject.userUrl = video.user.url
        videoObject.searchTerm = searchTerm

        videoObject.videoFiles.append(objectsIn: video.videoFiles.map { videoFile -> VideoFileObject in
            let videoFileObject = VideoFileObject()
            videoFileObject.id = videoFile.id
            videoFileObject.quality = videoFile.quality
            videoFileObject.fileType = videoFile.fileType
            videoFileObject.width = videoFile.width ?? 0
            videoFileObject.height = videoFile.height ?? 0
            videoFileObject.link = videoFile.link
            return videoFileObject
        })

        videoObject.videoPictures.append(objectsIn: video.videoPictures.map { videoPicture -> VideoPictureObject in
            let videoPictureObject = VideoPictureObject()
            videoPictureObject.id = videoPicture.id
            videoPictureObject.picture = videoPicture.picture
            videoPictureObject.nr = videoPicture.nr
            return videoPictureObject
        })

        return videoObject
    }
}
