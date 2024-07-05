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
            TextField("Search...", text: $viewModel.searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityIdentifier("Search...")

            if viewModel.isLoading {
                ProgressView()
                    .padding(.trailing, 8)
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No results found", systemImage: "video.slash")
                .symbolEffect(.pulse)
        }
        .accessibilityIdentifier("NoVideosFound")
    }

    var body: some View {
        VStack {
            searchView

            if viewModel.videos.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(viewModel.videos) { video in
                            VideoListCell(
                                imageUrl: video.image,
                                duration: video.duration,
                                width: video.width,
                                height: video.height,
                                username: video.user.name
                            )
                        }
                    }
                    .accessibilityIdentifier("VideoList")
                }
                .animation(.interactiveSpring, value: viewModel.videos)
            }
        }
        .navigationBarTitle("Pexels")
        .navigationBarTitle("Videos")
        .navigationBarItems(trailing: Text(viewModel.isOfflineMode ? "Offline" : "Online")
            .foregroundColor(viewModel.isOfflineMode ? .red : .green))
        .alert(isPresented: $viewModel.error.display) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    NavigationView {
        VideoListView()
    }
}
