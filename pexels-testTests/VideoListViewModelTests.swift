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
    var mockNetworkMonitor: MockNetworkMonitor!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockPexelsService = MockPexelsService()
        mockVideoRepository = MockVideoRepository()
        mockNetworkMonitor = MockNetworkMonitor()
        viewModel = VideoListViewModel(
            pexelsService: mockPexelsService,
            videoRepository: mockVideoRepository,
            networkMonitor: mockNetworkMonitor,
            receiveScheduler: DispatchQueue.global()
        )
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockPexelsService = nil
        mockVideoRepository = nil
        mockNetworkMonitor = nil
        cancellables = nil
        super.tearDown()
    }

    func testSearchVideosOnline() throws {
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
        mockNetworkMonitor.simulateConnectionChange(to: true)

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

    func testSearchVideosOffline() throws {
        let video = Video(
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
                VideoPicture(id: 133_236, picture: "https://static-videos.pexels.com/videos/1_448_735/pictures/preview-0.jpg", nr: 0)
            ]
        )

        try mockVideoRepository.save(videos: [video], searchTerm: "nature")

        let expectation = XCTestExpectation(description: "Wait for isOfflineMode to switch state")

        viewModel.$isOfflineMode
            .dropFirst()
            .sink { isOfflineMode in
                if isOfflineMode {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockNetworkMonitor.simulateConnectionChange(to: false)

        wait(for: [expectation], timeout: 3.0)

        viewModel.searchVideos(query: "nature")

        XCTAssertEqual(viewModel.videos.count, 1)
        XCTAssertEqual(viewModel.videos[0].id, 1_448_735)
    }

    func testSearchVideosIntegration() async throws {
        let service = PexelsService()
        let expectation = XCTestExpectation(description: "Fetch videos from Pexels API")

        var fetchedVideos: [Video] = []

        service.searchVideos(query: "nature", page: 1, perPage: 15)
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

    func testNetworkMonitorOnline() {
        let expectation = XCTestExpectation(description: "Network should be online")

        viewModel.isOfflineMode = true

        viewModel.$isOfflineMode
            .dropFirst()
            .sink { isOfflineMode in
                XCTAssertFalse(isOfflineMode)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockNetworkMonitor.simulateConnectionChange(to: true)

        wait(for: [expectation], timeout: 3.0)
    }

    func testNetworkMonitorOffline() {
        let expectation = XCTestExpectation(description: "Network should be offline")

        viewModel.isOfflineMode = true

        viewModel.$isOfflineMode
            .dropFirst()
            .sink { isOfflineMode in
                XCTAssertTrue(isOfflineMode)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockNetworkMonitor.simulateConnectionChange(to: false)

        wait(for: [expectation], timeout: 3.0)
    }

    func testSaveVideosErrorHandling() {
        let expectation = XCTestExpectation(description: "Wait for error to be triggered")

        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertTrue(error.display)
                XCTAssertEqual(error.message, "Error saving videos: Simulated save error")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mockVideoRepository.shouldThrowErrorOnSave = true
        viewModel.saveVideosToLocal(videos: [Video(
            id: 1_448_735,
            width: 4_096,
            height: 2_160,
            url: "https://www.pexels.com/video/video-of-forest-1448735/",
            image: "https://images.pexels.com/videos/1448735/free-video-1448735.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb",
            duration: 32,
            user: User(id: 574_687, name: "Ruvim Miksanskiy", url: "https://www.pexels.com/@digitech"),
            videoFiles: [],
            videoPictures: []
        )], query: "nature")

        wait(for: [expectation], timeout: 3.0)
    }

    func testLoadMoreVideos() {
        let initialVideos = (1...15).map { index in
            Video(
                id: index,
                width: 1_920,
                height: 1_080,
                url: "https://via.placeholder.com/\(index)",
                image: "https://via.placeholder.com/\(index)",
                duration: 120,
                user: User(id: index, name: "User \(index)", url: "https://via.placeholder.com/\(index)"),
                videoFiles: [],
                videoPictures: []
            )
        }

        mockPexelsService.videos = initialVideos
        let expectation1 = XCTestExpectation(description: "Wait for initial videos to load")

        viewModel.$videos
            .dropFirst()
            .sink { _ in
                expectation1.fulfill()
            }
            .store(in: &cancellables)

        viewModel.searchVideos(query: "nature")

        wait(for: [expectation1], timeout: 5.0)

        XCTAssertEqual(viewModel.videos.count, 15)

        let additionalVideos = (16...30).map { index in
            Video(
                id: index,
                width: 1_920,
                height: 1_080,
                url: "https://via.placeholder.com/\(index)",
                image: "https://via.placeholder.com/\(index)",
                duration: 120,
                user: User(id: index, name: "User \(index)", url: "https://via.placeholder.com/\(index)"),
                videoFiles: [],
                videoPictures: []
            )
        }

        mockPexelsService.videos.append(contentsOf: additionalVideos)
        let expectation2 = XCTestExpectation(description: "Wait for more videos to load")

        viewModel.$videos
            .dropFirst()
            .sink { _ in
                expectation2.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadMoreVideos()

        wait(for: [expectation2], timeout: 5.0)

        XCTAssertEqual(viewModel.videos.count, 30)
    }
}
