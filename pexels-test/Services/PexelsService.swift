//
//  PexelsService.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation

protocol PexelsServiceProtocol {
    func searchVideos(query: String) async throws -> [Video]
}

class PexelsService: PexelsServiceProtocol {
    private let apiKey = "v0ObPKn9nTfScULbfGZISdOWQ62rmjabEuvIt7R3jph10BDOW2EqWwFT"
    private let baseUrl = "https://api.pexels.com/videos"

    func searchVideos(query: String) async throws -> [Video] {
        let urlString = "\(baseUrl)/search?query=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(VideoResponse.self, from: data)
        return response.videos
    }
}
