// lib/infrastructure/datasources/youtube_video_datasource_impl.dart

import 'package:flutter/foundation.dart';
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeVideoDatasourceImpl implements VideoPostDatasource {
  final YoutubeExplode _yt = YoutubeExplode();

  // IDs de Shorts o videos de YouTube
  final List<String> _youtubeVideoIds = [
    'dQw4w9WgXcQ', // Rick Astley
    'L99xAhny-Ks', // Short
    'fJ9rUzIMcZQ', // Short
    'kJQP7kiw5Fk', // Despacito
  ];

  // Resguardo por si el dispositivo no tiene conexión a internet
  final List<VideoPost> _fallbackPosts = [
    VideoPost(
      caption: '[YouTube] Video de respaldo CDN',
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      likes: 14200,
      views: 95000,
    ),
  ];

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final String targetId =
        _youtubeVideoIds[(page - 1) % _youtubeVideoIds.length];

    if (kDebugMode) {
      print('[YouTube] Extrayendo enlace directo para ID: $targetId...');
    }

    try {
      // 1. Usamos clientes livianos (Safari, iOS, TV) para evitar el descifrado pesado de JS
      final manifest = await _yt.videos.streamsClient.getManifest(
        targetId,
        ytClients: [
  YoutubeApiClient.safari,
  YoutubeApiClient.ios,
  YoutubeApiClient.tv,
],
      ).timeout(const Duration(seconds: 8));

      String? directVideoUrl;

      // 2. Intentamos primero MUXED (MP4 unificado)
      if (manifest.muxed.isNotEmpty) {
        directVideoUrl = manifest.muxed.sortByVideoQuality().last.url.toString();
        if (kDebugMode) {
          print('[YouTube] Stream MUXED (MP4) encontrado para $targetId');
        }
      } 
      // 3. Si es un Short y no tiene Muxed, usamos HLS (.m3u8) que tiene audio+video juntos
      else if (manifest.hls.isNotEmpty) {
        directVideoUrl = manifest.hls.first.url.toString();
        if (kDebugMode) {
          print('[YouTube] Stream HLS (.m3u8) encontrado para Short $targetId');
        }
      }

      if (directVideoUrl != null && directVideoUrl.isNotEmpty) {
        // Intentamos obtener el título del video
        String title = 'YouTube Short ($targetId)';
        try {
          final videoInfo = await _yt.videos
              .get(targetId)
              .timeout(const Duration(seconds: 3));
          title = videoInfo.title;
        } catch (_) {}

        return [
          VideoPost(
            caption: '[YouTube] $title',
            videoUrl: directVideoUrl,
            likes: 18500,
            views: 120000,
          )
        ];
      }
    } catch (e) {
      if (kDebugMode) {
        print('[YouTube] Excepción al extraer $targetId: $e');
      }
    }

    // Solo si no hay red o falla la petición, se activa el respaldo
    return [_fallbackPosts[0]];
  }

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) async => [];

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];
}