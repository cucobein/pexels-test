
# Pexels Video App

## Overview

Pexels Video App is an iOS application that allows users to search and view videos from the Pexels API. The app provides a seamless experience with offline support, video caching, and pagination for large datasets. The app also includes a detailed video player view and a modern, user-friendly interface similar to Instagram.

## Features

- **Search Videos:** Search for videos using the Pexels API.
- **Offline Mode:** Automatically switches to offline mode when the network is unavailable, displaying cached videos.
- **Video Caching:** Caches video thumbnails and metadata for quick access.
- **Pagination:** Loads videos in pages to improve performance and user experience.
- **Video Detail View:** Displays video details and plays videos in a full-screen player.
- **Custom UI:** Modern UI with a search bar, video grid, and detailed video information.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/pexels-video-app.git
```

2. Navigate to the project directory:

```bash
cd pexels-video-app
```

3. Open the project in Xcode:

```bash
open pexels-test.xcodeproj
```

4. Install dependencies using Swift Package Manager (SPM). Xcode should handle this automatically when you open the project.

5. Build and run the project on your preferred simulator or device.

## Usage

### Searching for Videos

1. Open the app.
2. Use the search bar at the top to enter your search query.
3. The app will display a list of videos matching your search.

### Viewing Video Details

1. Tap on any video thumbnail in the search results.
2. The app will navigate to the video detail view, displaying the video player and detailed information.

### Offline Mode

- The app automatically switches to offline mode when the network is unavailable.
- Cached videos will be displayed when offline.

## Code Overview

### VideoListViewModel

- Manages the state and business logic for the video list view.
- Handles video search, pagination, and offline mode.

### VideoDetailView

- Displays the video player and detailed information about the selected video.
- Supports video playback and displays additional video metadata.

### VideoRepository

- Manages video caching using Realm.
- Provides methods to save and fetch videos from the local database.

### PexelsService

- Handles network requests to the Pexels API.
- Provides methods to search for videos and handle pagination.

### NetworkMonitor

- Monitors network connectivity status.
- Notifies the app of network status changes to switch between online and offline modes.

## Unit Tests

- Comprehensive unit tests are included to ensure the app's functionality.
- Tests cover the view models, repository, and network service.

## UI Tests

- UI tests verify the user interface and interactions.
- Ensure the app behaves correctly when performing searches and viewing video details.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Thanks to [Pexels](https://www.pexels.com/) for providing the API and video content.

---

## Screenshots

![1](https://github.com/cucobein/pexels-test/assets/13151201/3dd8e8c7-f5c9-4e28-959f-af74b65dc392)

![2](https://github.com/cucobein/pexels-test/assets/13151201/7ffddf2a-cdc6-4ae2-a522-c11035d2daf2)

Feel free to customize the README to better fit your project's specifics and any additional details you'd like to include.
