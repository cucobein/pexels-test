//
//  PexelsServiceTest.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import XCTest
import Combine
@testable import pexels_test

class PexelsServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testSearchVideos() async throws {
        guard let jsonData = Utils.loadJSONFromFile("PexelsSampleResponse") else {
            XCTFail("JSON file cannot be loaded.")
            return
        }

        let response = try JSONDecoder().decode(VideoResponse.self, from: jsonData)

        XCTAssertEqual(response.videos.count, 1)
        XCTAssertEqual(response.videos.first?.id, 1_448_735)
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
