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

    func searchVideos(query: String) -> AnyPublisher<[Video], Error> {
        Just(videos)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
