//
//  VideoListView.swift
//  pexels-test
//
//  Created by Hugo Ramirez on 04/07/24.
//

import SwiftUI
import Combine
import RealmSwift

// swiftlint:disable force_try
struct VideoListView: View {
    private enum Constants {
        static let searchBarCornerRadius = 8.0
        static let searchBarAccessibilityIdentifier = "Search"
        static let searchBarBackgroundOpacity = 0.3
        static let emptyStateAccessibilityIdentifier = "EmptyState"
        static let videoListAccessibilityIndentifier = "VideoList"
    }

    @StateObject private var viewModel = VideoListViewModel(
        pexelsService: PexelsService(),
        videoRepository: VideoRepository(realm: try! Realm())
    )

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private var searchView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.tertiaryForeground)

                TextField("", text: $viewModel.searchQuery)
                    .foregroundColor(.primaryForeground)
                    .padding(Padding.extraSmall)
                    .cornerRadius(Constants.searchBarCornerRadius)
                    .accessibilityIdentifier(Constants.searchBarAccessibilityIdentifier)

                if !viewModel.searchQuery.isEmpty {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.trailing, Padding.extraSmall)
                    } else {
                        Button {
                            viewModel.searchQuery = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.tertiaryForeground)
                        }
                    }
                }
            }
            .padding(.horizontal, Padding.extraSmall)
            .background(.tertiaryForeground.opacity(Constants.searchBarBackgroundOpacity))
            .cornerRadius(Constants.searchBarCornerRadius)
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label(L10n.VideoDetail.noResultsFound, systemImage: "video.slash")
                .foregroundColor(.primaryForeground)
                .font(Font.montserratBold.size(.heading))
                .symbolEffect(.pulse)
        }
        .accessibilityIdentifier(Constants.emptyStateAccessibilityIdentifier)
    }

    // swiftlint:disable closure_body_length
    var body: some View {
        VStack(spacing: .zero) {
            searchView

            if viewModel.videos.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Spacing.halfExtraSmall) {
                        ForEach(viewModel.videos) { video in
                            NavigationLink {
                                VideoDetailView(
                                    viewModel: VideoDetailViewModel(
                                        videoUrl: video.videoFiles.first?.link ?? "",
                                        username: video.user.name,
                                        width: video.width,
                                        height: video.height,
                                        duration: video.duration,
                                        quality: video.videoFiles.first?.quality ?? "",
                                        fileType: video.videoFiles.first?.fileType ?? "",
                                        placeholderImageUrl: video.image
                                    )
                                )
                            } label: {
                                VideoListCell(
                                    viewModel: VideoListCellViewModel(
                                        imageUrl: video.image,
                                        duration: video.duration,
                                        width: video.width,
                                        height: video.height,
                                        username: video.user.name
                                    )
                                )
                                .onAppear {
                                    if video == viewModel.videos.last {
                                        viewModel.loadMoreVideos()
                                    }
                                }
                            }
                        }
                    }
                    .accessibilityIdentifier(Constants.videoListAccessibilityIndentifier)
                }
                .animation(.interactiveSpring(), value: viewModel.videos)
            }
        }
        .background(.primaryBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L10n.VideoDetail.title)
                    .font(Font.montserratBold.size(.heading))
                    .foregroundStyle(.primaryForeground)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.isOfflineMode.toggle()
                } label: {
                    Image(systemName: viewModel.isOfflineMode ? "wifi.slash" : "wifi")
                        .foregroundStyle(viewModel.isOfflineMode ? .red : .green)
                }
            }
        }
        .alert(isPresented: $viewModel.error.display) {
            Alert(
                title: Text(L10n.VideoDetail.error),
                message: Text(viewModel.error.message),
                dismissButton: .default(Text(L10n.VideoDetail.ok))
            )
        }
    }
}

#Preview {
    NavigationView {
        VideoListView()
    }
}
