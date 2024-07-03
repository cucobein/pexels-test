//
//  PexelsService.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation
import Combine

protocol PexelsServiceProtocol {
    func searchVideos(query: String) -> AnyPublisher<[Video], Error>
}

class PexelsService: PexelsServiceProtocol {
    private let apiKey: String
    private let baseUrl = "https://api.pexels.com/videos"

    init() {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let secrets = try? PropertyListDecoder().decode([String: String].self, from: xml),
              let apiKey = secrets["PEXELS_API_KEY"] else {
            fatalError("API Key not found")
        }
        self.apiKey = apiKey
    }

    func searchVideos(query: String) -> AnyPublisher<[Video], Error> {
        let urlString = "\(baseUrl)/search?query=\(query)"
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
