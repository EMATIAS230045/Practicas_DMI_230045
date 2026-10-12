import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

class FeedProvider extends ChangeNotifier {
  final VideoPostRepository videosRepository;

  int activeTabIndex = 1;
  
  bool isDiscoverLoading = true;
  bool isForYouLoading = true;
  bool isFavoritesLoading = true;

  List<VideoPost> discoverVideos = [];
  List<VideoPost> forYouVideos = [];
  List<VideoPost> favoriteVideos = [];

  // Mapeos en memoria para el estado de Likes
  final Map<String, bool> _likedStatus = {};
  final Map<String, int> _likesCount = {};

  FeedProvider({required this.videosRepository});

  // Métodos de consulta pública para la UI
  bool isVideoLiked(String videoUrl) => _likedStatus[videoUrl] ?? false;

  int getVideoLikes(String videoUrl, int initialLikes) =>
      _likesCount[videoUrl] ?? initialLikes;

  Future<void> loadInitialFeeds() async {
    await Future.wait([
      loadForYou(),
      loadDiscover(),
      loadFavorites(),
    ]);
  }

  // Sincroniza los valores guardados en SharedPreferences con la lista cargada
  Future<void> _syncVideoLikes(List<VideoPost> posts) async {
    final prefs = await SharedPreferences.getInstance();
    for (var video in posts) {
      final url = video.videoUrl;
      if (!_likedStatus.containsKey(url)) {
        _likedStatus[url] = prefs.getBool('is_liked_$url') ?? false;
      }
      if (!_likesCount.containsKey(url)) {
        _likesCount[url] = prefs.getInt('likes_count_$url') ?? video.likes;
      }
    }
  }

  // Alterna el estado de Me Gusta (+1 o -1) y lo almacena localmente
  Future<void> toggleLike(VideoPost video) async {
    final url = video.videoUrl;
    final currentlyLiked = isVideoLiked(url);
    final currentLikes = getVideoLikes(url, video.likes);

    final newLikedState = !currentlyLiked;
    final newLikesCount = newLikedState ? currentLikes + 1 : currentLikes - 1;

    // Actualizamos el estado en memoria
    _likedStatus[url] = newLikedState;
    _likesCount[url] = newLikesCount;

    notifyListeners();

    // Guardamos los cambios en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_liked_$url', newLikedState);
    await prefs.setInt('likes_count_$url', newLikesCount);
  }

  Future<void> loadDiscover() async {
    isDiscoverLoading = true;
    notifyListeners();
    discoverVideos = await videosRepository.getTrendingVideosByPage(1);
    await _syncVideoLikes(discoverVideos);
    isDiscoverLoading = false;
    notifyListeners();
  }

  Future<void> loadForYou() async {
    isForYouLoading = true;
    notifyListeners();
    forYouVideos = await videosRepository.getForYouVideosByPage(1);
    await _syncVideoLikes(forYouVideos);
    isForYouLoading = false;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    isFavoritesLoading = true;
    notifyListeners();
    favoriteVideos = await videosRepository.getFavoriteVideosByUser('user_1');
    await _syncVideoLikes(favoriteVideos);
    isFavoritesLoading = false;
    notifyListeners();
  }

  void setActiveTab(int index) {
    activeTabIndex = index;
    notifyListeners();
  }
}