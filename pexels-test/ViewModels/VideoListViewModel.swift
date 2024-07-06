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
    @Published var currentPage: Int = 1
    @Published var hasMoreVideos: Bool = true
    private let perPage = 15

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
        currentPage = 1
        videos = []
        hasMoreVideos = true
        fetchVideos(query: query, page: currentPage)
    }

    func loadMoreVideos() {
        guard !isLoading, hasMoreVideos else { return }
        currentPage += 1
        fetchVideos(query: searchQuery, page: currentPage)
    }

    private func fetchVideos(query: String, page: Int) {
        if isOfflineMode {
            loadVideosFromLocal(query: query, page: page)
        } else {
            loadVideosFromAPI(query: query, page: page)
        }
    }

    private func loadVideosFromAPI(query: String, page: Int) {
        isLoading = true

        print("Page here: \(page)")

        pexelsService.searchVideos(query: query, page: page, perPage: perPage)
            .receive(on: receiveScheduler)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure:
                    self.loadVideosFromLocal(query: query, page: page)

                case .finished:
                    break
                }
            }, receiveValue: { videos in
                if page == 1 {
                    self.videos = videos
                } else {
                    self.videos += videos
                }
                self.hasMoreVideos = videos.count == self.perPage
                self.saveVideosToLocal(videos: self.videos, query: query)
            })
            .store(in: &cancellables)
    }

    private func loadVideosFromLocal(query: String, page: Int) {
        isLoading = true
        let videoObjects = videoRepository.fetchVideos(for: query)
        let startIndex = (page - 1) * perPage
        let endIndex = min(startIndex + perPage, videoObjects.count)
        if startIndex < endIndex {
            let videosPage = Array(videoObjects[startIndex..<endIndex])
            let videos = videosPage.map { videoObject in
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
            if page == 1 {
                self.videos = videos
            } else {
                self.videos += videos
            }
            self.hasMoreVideos = videos.count == self.perPage
        } else {
            self.hasMoreVideos = false
        }
        isLoading = false
    }

    func saveVideosToLocal(videos: [Video], query: String) {
        do {
            try videoRepository.save(videos: videos, searchTerm: query)
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
                    self?.fetchVideos(query: self?.searchQuery ?? "", page: 1)
                } else {
                    self?.loadVideosFromLocal(query: self?.searchQuery ?? "", page: 1)
                }
            }
            .store(in: &cancellables)

        networkMonitor.startMonitoring()
    }
}
