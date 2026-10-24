import 'package:dio/dio.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/api_video_model.dart';

class ApiVideoDatasource implements VideoPostDatasource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://tu-api.com/api', // Reemplaza con la URL de tu API
  ));

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    try {
      final response = await _dio.get('/trending', queryParameters: {'page': page});

      if (response.statusCode == 200) {
        final List<dynamic> listJson = response.data;
        return listJson
            .map((v) => ApiVideoModel.fromJson(v).toVideoPostEntity())
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) async {
    // Si esta clase se consulta directamente para "Para ti", podemos retornar lista vacía o implementar
    return [];
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async {
    return [];
  }
}