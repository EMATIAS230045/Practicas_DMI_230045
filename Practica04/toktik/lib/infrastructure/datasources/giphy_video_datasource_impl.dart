// lib/infrastructure/datasources/giphy_video_datasource_impl.dart
import 'package:dio/dio.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/giphy_video_model.dart';

class GiphyVideoDatasource implements VideoPostDatasource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.giphy.com/v1',
  ));

  final String _apiKey = '24BneiSDpazLadgHrlmtuwtjH4thU4rs';

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    try {
      final response = await _dio.get('/gifs/trending', queryParameters: {
        'api_key': _apiKey,
        'limit': 10,
        'offset': (page - 1) * 10,
        'rating': 'g',
      });

      if (response.statusCode == 200) {
        final List<dynamic> listJson = response.data['data'] ?? [];
        return listJson
            .map((v) => GiphyVideoModel.fromJson(v).toVideoPostEntity())
            .where((post) => post.videoUrl.isNotEmpty)
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) async => [];

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];
}