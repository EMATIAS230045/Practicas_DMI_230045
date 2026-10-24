import 'package:dio/dio.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/pixabay_video_model.dart';
class PixabayVideoDatasource implements VideoPostDatasource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://pixabay.com/api/videos',
  ));

  final String _apiKey = '58076732-e89e245a499a91257b03b89fc';
 // Aqui se implementa todo el codigo referente a la obtencion de los videos de la api de pixabay
  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    try {
      final response = await _dio.get('', queryParameters: {
        'key': _apiKey,
        'per_page': 10,
        'page': page,
      });

      if (response.statusCode == 200) {
        final List<dynamic> hits = response.data['hits'] ?? [];
        
        return hits
            .map((v) => PixabayVideoModel.fromJson(v).toVideoPostEntity())
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) async {
    return [];
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async {
    return [];
  }
}