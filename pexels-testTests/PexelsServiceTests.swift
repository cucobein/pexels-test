//
//  PexelsServiceTest.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import XCTest
@testable import pexels_test

class PexelsServiceTests: XCTestCase {
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

        let videos = try await service.searchVideos(query: "nature")

        XCTAssertFalse(videos.isEmpty)
    }
}
