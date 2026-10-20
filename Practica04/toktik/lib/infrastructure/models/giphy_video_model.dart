import 'package:toktik/domain/entities/video_post.dart';

class GiphyVideoModel {
  final String title;
  final String videoUrl;
  final int likes;
  final int views;

  GiphyVideoModel({
    required this.title,
    required this.videoUrl,
    required this.likes,
    required this.views,
  });

  factory GiphyVideoModel.fromJson(Map<String, dynamic> json) {
    // Busca primero la versión MP4 con audio (Clips) o la versión MP4 original
    final String url = json['video']?['assets']?['720p']?['url'] ??
        json['video']?['assets']?['small']?['url'] ??
        json['images']?['original']?['mp4'] ??
        json['images']?['looping']?['mp4'] ??
        '';

    return GiphyVideoModel(
      title: json['title'] != null && (json['title'] as String).isNotEmpty
          ? json['title']
          : 'Giphy Content',
      videoUrl: url,
      likes: (json['id']?.hashCode ?? 0).abs() % 1500 + 100,
      views: (json['title']?.hashCode ?? 0).abs() % 8000 + 500,
    );
  }

  VideoPost toVideoPostEntity() => VideoPost(
        caption: '[Giphy] $title',
        videoUrl: videoUrl,
        likes: likes,
        views: views,
      );
}