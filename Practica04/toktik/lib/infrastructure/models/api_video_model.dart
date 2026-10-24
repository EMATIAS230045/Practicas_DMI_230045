import 'package:toktik/domain/entities/video_post.dart';

class ApiVideoModel {
  final String name;
  final String videoUrl;
  final int likes;
  final int views;

  ApiVideoModel({
    required this.name,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
  });

  // Mapea la respuesta JSON de la API
  factory ApiVideoModel.fromJson(Map<String, dynamic> json) => ApiVideoModel(
        name: json['name'] ?? json['caption'] ?? 'Sin título',
        videoUrl: json['videoUrl'] ?? json['url'] ?? '',
        likes: json['likes'] ?? 0,
        views: json['views'] ?? 0,
      );

  // Mantiene el mismo método que tu LocalVideoModel para convertirlo a la Entidad
  VideoPost toVideoPostEntity() => VideoPost(
        caption: name,
        videoUrl: videoUrl,
        likes: likes,
        views: views,
      );
}