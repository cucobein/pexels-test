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
    @Published var error: (display: Bool, message: String) = (false, "")
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false

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

        setupBindings()
    }

    func searchVideos(query: String) {
        if isOfflineMode {
            loadVideosFromLocal()
        } else {
            loadVideosFromAPI(query: query)
        }
    }

    private func loadVideosFromAPI(query: String) {
        isLoading = true
        pexelsService.searchVideos(query: query)
            .receive(on: receiveScheduler)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure:
                    self.loadVideosFromLocal()
                    
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
        isLoading = true
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
        isLoading = false
    }

    func saveVideosToLocal(videos: [Video]) {
        do {
            try videoRepository.save(videos: videos)
        } catch {
            self.error = (true, "Error saving videos: \(error.localizedDescription)")
        }
    }

    private func setupBindings() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: receiveScheduler)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchVideos(query: query)
            }
            .store(in: &cancellables)

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
}
