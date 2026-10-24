import 'package:toktik/domain/entities/video_post.dart';

class PixabayVideoModel {
  final String name;
  final String videoUrl;
  final int likes;
  final int views;

  PixabayVideoModel({
    required this.name,
    required this.videoUrl,
    required this.likes,
    required this.views,
  });

  factory PixabayVideoModel.fromJson(Map<String, dynamic> json) {
    // Pixabay agrupa las resoluciones dentro del objeto 'videos'
    final Map<String, dynamic> videos = json['videos'] ?? {};
    
    // Priorizamos resolución 'medium' o 'small' para mejor fluidez en móvil
    final String url = videos['medium']?['url'] ?? 
                       videos['small']?['url'] ?? 
                       videos['tiny']?['url'] ?? '';

    return PixabayVideoModel(
      name: json['tags'] ?? 'Pixabay Video',
      videoUrl: url,
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
    );
  }

  // Convierte el modelo a la entidad de tu dominio
  VideoPost toVideoPostEntity() => VideoPost(
      caption: '[Pixabay] $name', 
      videoUrl: videoUrl,
      likes: likes,
      views: views,
    );
}