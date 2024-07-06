//
//  MockPexelsService.swift
//  pexels-testTests
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Combine
@testable import pexels_test

class MockPexelsService: PexelsServiceProtocol {
    var videos: [Video] = []

    func searchVideos(query: String, page: Int, perPage: Int) -> AnyPublisher<[Video], Error> {
        let startIndex = (page - 1) * perPage
        let endIndex = min(startIndex + perPage, videos.count)
        let pageVideos = Array(videos[startIndex..<endIndex])

        return Just(pageVideos)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
