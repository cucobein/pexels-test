//
//  VideoRepository.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import RealmSwift

protocol VideoRepositoryProtocol {
    func save(videos: [Video])
    func fetchVideos() -> [VideoObject]
}

class VideoRepository: VideoRepositoryProtocol {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func save(videos: [Video]) {
        do {
            try realm.write {
                let videoObjects = videos.map { video -> VideoObject in
                    initializeVideObject(video: video)
                }
                realm.add(videoObjects, update: .modified)
            }
        } catch {
            print("Error saving videos to Realm: \(error.localizedDescription)")
        }
    }

    func fetchVideos() -> [VideoObject] {
        Array(realm.objects(VideoObject.self))
    }

    private func initializeVideObject(video: Video) -> VideoObject {
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

        videoObject.videoPictures.append(
            objectsIn: video.videoPictures.map { videoPicture -> VideoPictureObject in
                let videoPictureObject = VideoPictureObject()
                videoPictureObject.id = videoPicture.id
                videoPictureObject.picture = videoPicture.picture
                videoPictureObject.nr = videoPicture.nr
                return videoPictureObject
            }
        )

        return videoObject
    }
}
