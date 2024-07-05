//
//  VideoRepository.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import RealmSwift

protocol VideoRepositoryProtocol {
    func save(videos: [Video], searchTerm: String) throws
    func fetchVideos(for searchTerm: String) -> [VideoObject]
}

class VideoRepository: VideoRepositoryProtocol {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func save(videos: [Video], searchTerm: String) throws {
        do {
            try realm.write {
                deleteVideos(for: searchTerm)
                let videoObjects = videos.map { video -> VideoObject in
                    initializeVideoObject(video: video, searchTerm: searchTerm)
                }
                realm.add(videoObjects, update: .modified)
            }
        } catch {
            throw error
        }
    }

    func fetchVideos(for searchTerm: String) -> [VideoObject] {
        Array(realm.objects(VideoObject.self).filter("searchTerm == %@", searchTerm))
    }

    private func deleteVideos(for searchTerm: String) {
        let videosToDelete = realm.objects(VideoObject.self).filter("searchTerm == %@", searchTerm)
        realm.delete(videosToDelete)
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
