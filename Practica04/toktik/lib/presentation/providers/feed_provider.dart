import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

class FeedProvider extends ChangeNotifier {
  final VideoPostRepository videosRepository;

  int activeTabIndex = 1; // 0: Discover, 1: For You, 2: Favorites
  
  bool isDiscoverLoading = true;
  bool isForYouLoading = true;
  bool isFavoritesLoading = true;

  List<VideoPost> discoverVideos = [];
  List<VideoPost> forYouVideos = [];
  List<VideoPost> favoriteVideos = [];

  FeedProvider({required this.videosRepository});

  Future<void> loadInitialFeeds() async {
    await Future.wait([
      loadForYou(),
      loadDiscover(),
      loadFavorites(),
    ]);
  }

  Future<void> loadDiscover() async {
    isDiscoverLoading = true;
    notifyListeners();
    discoverVideos = await videosRepository.getTrendingVideosByPage(1);
    isDiscoverLoading = false;
    notifyListeners();
  }

  Future<void> loadForYou() async {
    isForYouLoading = true;
    notifyListeners();
    forYouVideos = await videosRepository.getForYouVideosByPage(1);
    isForYouLoading = false;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    isFavoritesLoading = true;
    notifyListeners();
    favoriteVideos = await videosRepository.getFavoriteVideosByUser('user_1');
    isFavoritesLoading = false;
    notifyListeners();
  }

  void setActiveTab(int index) {
    activeTabIndex = index;
    notifyListeners();
  }
}