//
//  VideoRepositoryTests.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

@testable import pexels_test
import XCTest

// swiftlint:disable line_length
class VideoRepositoryTests: XCTestCase {
    var repository: VideoRepositoryProtocol!

    override func setUp() {
        super.setUp()
        repository = MockVideoRepository()
    }

    func testSaveAndFetchVideos() {
        guard let jsonData = Utils.loadJSONFromFile("PexelsSampleResponse") else {
            XCTFail("JSON file cannot be loaded.")
            return
        }

        do {
            let response = try JSONDecoder().decode(VideoResponse.self, from: jsonData)
            let videos = response.videos

            try? repository.save(videos: videos)

            let fetchedVideos = repository.fetchVideos()

            XCTAssertEqual(fetchedVideos.count, 1)
            XCTAssertEqual(fetchedVideos.first?.id, 1_448_735)
            XCTAssertEqual(fetchedVideos.first?.width, 4_096)
            XCTAssertEqual(fetchedVideos.first?.height, 2_160)
            XCTAssertEqual(fetchedVideos.first?.url, "https://www.pexels.com/video/video-of-forest-1448735/")
            XCTAssertEqual(fetchedVideos.first?.image, "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb")
            XCTAssertEqual(fetchedVideos.first?.duration, 32)
            XCTAssertEqual(fetchedVideos.first?.userName, "Ruvim Miksanskiy")
            XCTAssertEqual(fetchedVideos.first?.userUrl, "https://www.pexels.com/@digitech")

            XCTAssertEqual(fetchedVideos.first?.videoFiles.count, 7)
            XCTAssertEqual(fetchedVideos.first?.videoFiles.first?.id, 58_649)
            XCTAssertEqual(fetchedVideos.first?.videoFiles.first?.quality, "sd")
            XCTAssertEqual(fetchedVideos.first?.videoFiles.first?.fileType, "video/mp4")
            XCTAssertEqual(fetchedVideos.first?.videoFiles.first?.width, 640)
            XCTAssertEqual(fetchedVideos.first?.videoFiles.first?.height, 338)
            XCTAssertEqual(fetchedVideos.first?.videoFiles.first?.link, "https://player.vimeo.com/external/291648067.sd.mp4?s=7f9ee1f8ec1e5376027e4a6d1d05d5738b2fbb29&profile_id=164&oauth2_token_id=57447761")

            XCTAssertEqual(fetchedVideos.first?.videoPictures.count, 15)
            XCTAssertEqual(fetchedVideos.first?.videoPictures.first?.id, 133_236)
            XCTAssertEqual(fetchedVideos.first?.videoPictures.first?.picture, "https://static-videos.pexels.com/videos/1448735/pictures/preview-0.jpg")
            XCTAssertEqual(fetchedVideos.first?.videoPictures.first?.nr, 0)
        } catch {
            XCTFail("Decoding error: \(error.localizedDescription)")
        }
    }
}
