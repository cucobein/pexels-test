//
//  PexelsService.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation
import Combine

protocol PexelsServiceProtocol {
    func searchVideos(query: String, page: Int, perPage: Int) -> AnyPublisher<[Video], Error>
}

class PexelsService: PexelsServiceProtocol {
    private let apiKey = "v0ObPKn9nTfScULbfGZISdOWQ62rmjabEuvIt7R3jph10BDOW2EqWwFT"
    private let baseUrl = "https://api.pexels.com/videos"

    func searchVideos(query: String, page: Int, perPage: Int) -> AnyPublisher<[Video], Error> {
        let urlString = "\(baseUrl)/search?query=\(query)&page=\(page)&per_page=\(perPage)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: VideoResponse.self, decoder: JSONDecoder())
            .map { $0.videos }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
