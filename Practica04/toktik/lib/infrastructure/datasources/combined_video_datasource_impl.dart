// lib/infrastructure/datasources/combined_video_datasource_impl.dart

import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';

class CombinedVideoDatasourceImpl implements VideoPostDatasource {
  final VideoPostDatasource localDatasource;
  final VideoPostDatasource pixabayDatasource;
  final VideoPostDatasource giphyDatasource;
  final VideoPostDatasource tiktokDatasource;

  CombinedVideoDatasourceImpl({
    required this.localDatasource,
    required this.pixabayDatasource,
    required this.giphyDatasource,
    required this.tiktokDatasource,
  });

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) async {
    return await localDatasource.getForYouVideosByPage(page);
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final results = await Future.wait([
      pixabayDatasource.getTrendingVideosByPage(page).catchError((_) => <VideoPost>[]),
      giphyDatasource.getTrendingVideosByPage(page).catchError((_) => <VideoPost>[]),
      tiktokDatasource.getTrendingVideosByPage(page).catchError((_) => <VideoPost>[]),
    ]);

    final pixabayVideos = results[0];
    final giphyVideos = results[1];
    final tiktokVideos = results[2];

    final List<VideoPost> combined = [];
    final int maxLength = [
      pixabayVideos.length,
      giphyVideos.length,
      tiktokVideos.length,
    ].reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxLength; i++) {
      if (i < pixabayVideos.length) combined.add(pixabayVideos[i]);
      if (i < giphyVideos.length) combined.add(giphyVideos[i]);
      if (i < tiktokVideos.length) combined.add(tiktokVideos[i]);
    }

    return combined;
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async {
    return await localDatasource.getFavoriteVideosByUser(userID);
  }
}