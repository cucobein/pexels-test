//
//  VideoRepositoryTests.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import XCTest
import RealmSwift
@testable import pexels_test

// swiftlint:disable line_length
// swiftlint:disable force_try
class VideoRepositoryTests: XCTestCase {
    var repository: VideoRepository!
    var realm: Realm!

    override func setUp() {
        super.setUp()
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "TestRealm"
        realm = try! Realm(configuration: config)
        repository = VideoRepository(realm: realm)
    }

    override func tearDown() {
        try! realm.write {
            realm.deleteAll()
        }
        realm = nil
        repository = nil
        super.tearDown()
    }

    func testSaveAndFetchVideos() {
        let videos = [
            Video(
                id: 1_448_735,
                width: 4_096,
                height: 2_160,
                url: "https://www.pexels.com/video/video-of-forest-1448735/",
                image: "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
                duration: 32,
                user: User(id: 574_687, name: "Ruvim Miksanskiy", url: "https://www.pexels.com/@digitech"),
                videoFiles: [VideoFile(id: 58_649, quality: "sd", fileType: "video/mp4", width: 640, height: 338, link: "https://player.vimeo.com/external/291648067.sd.mp4?s=7f9ee1f8ec1e5376027e4a6d1d05d5738b2fbb29&profile_id=164&oauth2_token_id=57447761")],
                videoPictures: [VideoPicture(id: 133_236, picture: "https://static-videos.pexels.com/videos/1_448_735/pictures/preview-0.jpg", nr: 0)]
            )
        ]

        XCTAssertNoThrow(try repository.save(videos: videos, searchTerm: "nature"))

        let fetchedVideos = repository.fetchVideos(for: "nature")
        XCTAssertEqual(fetchedVideos.count, 1)
        XCTAssertEqual(fetchedVideos[0].id, 1_448_735)
    }

    func testDeleteVideosForSearchTerm() {
        let natureVideos = [
            Video(
                id: 1_448_735,
                width: 4_096,
                height: 2_160,
                url: "https://www.pexels.com/video/video-of-forest-1448735/",
                image: "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
                duration: 32,
                user: User(id: 574_687, name: "Ruvim Miksanskiy", url: "https://www.pexels.com/@digitech"),
                videoFiles: [VideoFile(id: 58_649, quality: "sd", fileType: "video/mp4", width: 640, height: 338, link: "https://player.vimeo.com/external/291648067.sd.mp4?s=7f9ee1f8ec1e5376027e4a6d1d05d5738b2fbb29&profile_id=164&oauth2_token_id=57447761")],
                videoPictures: [VideoPicture(id: 133_236, picture: "https://static-videos.pexels.com/videos/1_448_735/pictures/preview-0.jpg", nr: 0)]
            )
        ]

        let mountainVideos = [
            Video(
                id: 1_448_736,
                width: 4_096,
                height: 2_160,
                url: "https://www.pexels.com/video/video-of-forest-1448735/",
                image: "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
                duration: 32,
                user: User(id: 574_687, name: "Ruvim Miksanskiy", url: "https://www.pexels.com/@digitech"),
                videoFiles: [VideoFile(id: 58_649, quality: "sd", fileType: "video/mp4", width: 640, height: 338, link: "https://player.vimeo.com/external/291648067.sd.mp4?s=7f9ee1f8ec1e5376027e4a6d1d05d5738b2fbb29&profile_id=164&oauth2_token_id=57447761")],
                videoPictures: [VideoPicture(id: 133_236, picture: "https://static-videos.pexels.com/videos/1_448_735/pictures/preview-0.jpg", nr: 0)]
            )
        ]

        XCTAssertNoThrow(try repository.save(videos: natureVideos, searchTerm: "nature"))
        XCTAssertNoThrow(try repository.save(videos: mountainVideos, searchTerm: "mountains"))

        var fetchedVideos = repository.fetchVideos(for: "nature")
        XCTAssertEqual(fetchedVideos.count, 1)

        fetchedVideos = repository.fetchVideos(for: "mountains")
        XCTAssertEqual(fetchedVideos.count, 1)

        XCTAssertNoThrow(try repository.save(videos: [], searchTerm: "nature"))
        fetchedVideos = repository.fetchVideos(for: "nature")
        XCTAssertEqual(fetchedVideos.count, 0)

        fetchedVideos = repository.fetchVideos(for: "mountains")
        XCTAssertEqual(fetchedVideos.count, 1)
    }
}
