//
//  MockVideoRepository.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

@testable import pexels_test
import Foundation

class MockVideoRepository: VideoRepositoryProtocol {
    var videos: [VideoObject] = []
    var shouldThrowErrorOnSave = false

    func save(videos: [Video]) throws {
        if shouldThrowErrorOnSave {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Simulated save error"])
        }
        self.videos = videos.map { video in
            let videoObject = VideoObject()
            videoObject.id = video.id
            videoObject.width = video.width
            videoObject.height = video.height
            videoObject.url = video.url
            videoObject.image = video.image
            videoObject.duration = video.duration
            videoObject.userName = video.user.name
            videoObject.userUrl = video.user.url

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

    func fetchVideos() -> [VideoObject] {
        videos
    }
}
