import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/infrastructure/models/local_video_model.dart';
import 'package:toktik/shared/data/local_video_posts.dart';

class LocalVideoDatasource implements VideoPostDatasource {

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return videoPosts
        .map((v) => LocalVideoModel.fromJson(v).toVideoPostEntity())
        .toList();
  }

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Devuelve los videos en orden invertido para simular contenido distinto
    return videoPosts.reversed
        .map((v) => LocalVideoModel.fromJson(v).toVideoPostEntity())
        .toList();
  }

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Devuelve solo una muestra de los videos favoritos
    return videoPosts.take(2)
        .map((v) => LocalVideoModel.fromJson(v).toVideoPostEntity())
        .toList();
  }
}