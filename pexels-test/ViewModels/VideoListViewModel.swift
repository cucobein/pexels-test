//
//  VideoListViewModel.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 02/07/24.
//

import Foundation
import Combine
import RealmSwift

class VideoListViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isOfflineMode: Bool = false

    private let pexelsService: PexelsServiceProtocol
    private let videoRepository: VideoRepositoryProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private var cancellables = Set<AnyCancellable>()
    private let receiveScheduler: DispatchQueue

    init(
        pexelsService: PexelsServiceProtocol,
        videoRepository: VideoRepositoryProtocol,
        networkMonitor: NetworkMonitorProtocol = NetworkMonitor(),
        receiveScheduler: DispatchQueue = .main
    ) {
        self.pexelsService = pexelsService
        self.videoRepository = videoRepository
        self.networkMonitor = networkMonitor
        self.receiveScheduler = receiveScheduler

        networkMonitor.isConnectedPublisher
            .receive(on: receiveScheduler)
            .sink { [weak self] isConnected in
                self?.isOfflineMode = !isConnected
                if isConnected {
                    self?.loadVideosFromAPI(query: "nature")
                } else {
                    self?.loadVideosFromLocal()
                }
            }
            .store(in: &cancellables)

        networkMonitor.startMonitoring()
    }

    func searchVideos(query: String) {
        if isOfflineMode {
            loadVideosFromLocal()
        } else {
            loadVideosFromAPI(query: query)
        }
    }

    private func loadVideosFromAPI(query: String) {
        pexelsService.searchVideos(query: query)
            .receive(on: receiveScheduler)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching videos: \(error.localizedDescription)")
                    self.loadVideosFromLocal()  // fallback to local data if API fails
                case .finished:
                    break
                }
            }, receiveValue: { videos in
                self.videos = videos
                self.saveVideosToLocal(videos: videos)
            })
            .store(in: &cancellables)
    }

    private func loadVideosFromLocal() {
        let videoObjects = videoRepository.fetchVideos()
        self.videos = videoObjects.map { videoObject in
            Video(
                id: videoObject.id,
                width: videoObject.width,
                height: videoObject.height,
                url: videoObject.url,
                image: videoObject.image,
                duration: videoObject.duration,
                user: User(id: videoObject.userName.hash, name: videoObject.userName, url: videoObject.userUrl),
                videoFiles: videoObject.videoFiles.map { videoFileObject in
                    VideoFile(
                        id: videoFileObject.id,
                        quality: videoFileObject.quality,
                        fileType: videoFileObject.fileType,
                        width: videoFileObject.width,
                        height: videoFileObject.height,
                        link: videoFileObject.link
                    )
                },
                videoPictures: videoObject.videoPictures.map { videoPictureObject in
                    VideoPicture(
                        id: videoPictureObject.id,
                        picture: videoPictureObject.picture,
                        nr: videoPictureObject.nr
                    )
                }
            )
        }
    }

    private func saveVideosToLocal(videos: [Video]) {
        videoRepository.save(videos: videos)
    }
}
