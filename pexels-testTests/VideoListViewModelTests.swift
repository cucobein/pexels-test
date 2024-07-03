//
//  VideoListViewModelTests.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import XCTest
import Combine
@testable import pexels_test

// swiftlint:disable line_length
class VideoListViewModelTests: XCTestCase {
    var viewModel: VideoListViewModel!
    var mockPexelsService: MockPexelsService!
    var mockVideoRepository: MockVideoRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockPexelsService = MockPexelsService()
        mockVideoRepository = MockVideoRepository()
        viewModel = VideoListViewModel(pexelsService: mockPexelsService, videoRepository: mockVideoRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockPexelsService = nil
        mockVideoRepository = nil
        cancellables = nil
        super.tearDown()
    }

    func testSearchVideosOnline() {
        let expectedVideos = [
            Video(
                id: 1_448_735,
                width: 4_096,
                height: 2_160,
                url: "https://www.pexels.com/video/video-of-forest-1448735/",
                image: "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
                duration: 32,
                user: User(id: 574_687, name: "Ruvim Miksanskiy", url: "https://www.pexels.com/@digitech"),
                videoFiles: [
                    VideoFile(id: 58_649, quality: "sd", fileType: "video/mp4", width: 640, height: 338, link: "https://player.vimeo.com/external/291648067.sd.mp4?s=7f9ee1f8ec1e5376027e4a6d1d05d5738b2fbb29&profile_id=164&oauth2_token_id=57447761")
                ],
                videoPictures: [
                    VideoPicture(id: 133_236, picture: "https://static-videos.pexels.com/videos/1448735/pictures/preview-0.jpg", nr: 0)
                ]
            )
        ]
        mockPexelsService.videos = expectedVideos
        viewModel.isOfflineMode = false

        let expectation = XCTestExpectation(description: "Fetch videos from API")

        viewModel.$videos
            .dropFirst()
            .sink { videos in
                if !videos.isEmpty {
                    XCTAssertEqual(videos, expectedVideos)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.searchVideos(query: "nature")

        wait(for: [expectation], timeout: 10.0)
    }

    func testSearchVideosOffline() {
        let expectedVideos = [
            VideoObject(value: ["id": 1_448_735, "url": "https://www.pexels.com/video/video-of-forest-1448735/", "image": "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb", "duration": 32, "userName": "Ruvim Miksanskiy", "userUrl": "https://www.pexels.com/@digitech"])
        ]
        mockVideoRepository.videos = expectedVideos
        viewModel.isOfflineMode = true

        viewModel.searchVideos(query: "nature")

        XCTAssertEqual(viewModel.videos.count, 1)
        XCTAssertEqual(viewModel.videos[0].id, 1_448_735)
    }

    func testLoadVideos() {
        let expectedVideos = [
            VideoObject(value: ["id": 1_448_735, "url": "https://www.pexels.com/video/video-of-forest-1448735/", "image": "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb", "duration": 32, "userName": "Ruvim Miksanskiy", "userUrl": "https://www.pexels.com/@digitech"])
        ]
        mockVideoRepository.videos = expectedVideos

        viewModel.isOfflineMode = true
        viewModel.searchVideos(query: "nature")

        XCTAssertEqual(viewModel.videos.count, 1)
        XCTAssertEqual(viewModel.videos[0].id, 1_448_735)
    }

    func testSearchVideosIntegration() async throws {
        let service = PexelsService()
        let expectation = XCTestExpectation(description: "Fetch videos from Pexels API")

        var fetchedVideos: [Video] = []

        service.searchVideos(query: "nature")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Error fetching videos: \(error)")
                }
            }, receiveValue: { videos in
                fetchedVideos = videos
                expectation.fulfill()
            })
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 10.0)
        XCTAssertFalse(fetchedVideos.isEmpty)
    }
}
