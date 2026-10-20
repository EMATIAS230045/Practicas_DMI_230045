// lib/infrastructure/datasources/tiktok_video_datasource_impl.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:toktik/domain/datasources/video_posts_datasource.dart';
import 'package:toktik/domain/entities/video_post.dart';

class TikTokVideoDatasourceImpl implements VideoPostDatasource {
  final http.Client client;
  final String apiKey;

  // Lista con tus 6 enlaces reales de TikTok
  static const List<String> targetTikTokUrls = [
    'https://www.tiktok.com/@hunainn/video/7697656998690835732',
    'https://www.tiktok.com/@aldri_fm/video/7666967711750098197',
    'https://www.tiktok.com/@meowtakeover/video/7691423726994328840',
    'https://www.tiktok.com/@jeishua9/video/7694106707756059924',
    'https://www.tiktok.com/@comprameunamaruchan1/video/7684836233675050258',
    'https://www.tiktok.com/@dayanantv.0/video/7696961433958911253',
    'https://www.tiktok.com/@shamyyvswrld17_/video/7682143793356819726',
  ];

  TikTokVideoDatasourceImpl({
    required this.client,
    required this.apiKey,
  });

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    final List<VideoPost> posts = [];

    for (int i = 0; i < targetTikTokUrls.length; i++) {
      final tiktokUrl = targetTikTokUrls[i];

      // Pausa de 250 ms entre peticiones para evitar el bloqueo anti-bot
      if (i > 0) {
        await Future.delayed(const Duration(milliseconds: 250));
      }

      try {
        final response = await client.post(
          Uri.parse('https://www.tikwm.com/api/'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          },
          body: {'url': tiktokUrl},
        ).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['code'] == 0 && data['data'] != null) {
            final videoData = data['data'];
            final String playUrl =
                videoData['play'] ?? videoData['wmplay'] ?? '';

            if (playUrl.isNotEmpty) {
              final finalUrl = playUrl.startsWith('http')
                  ? playUrl
                  : 'https://www.tikwm.com$playUrl';

              // Formateamos el título para incluir siempre "Video de TikTok"
              final String rawTitle = videoData['title'] ?? '';
              final String formattedCaption = rawTitle.isNotEmpty
                  ? 'Video de TikTok: $rawTitle'
                  : 'Video de TikTok';

              posts.add(
                VideoPost(
                  caption: formattedCaption,
                  videoUrl: finalUrl,
                  likes: videoData['digg_count'] ?? 1000,
                  views: videoData['play_count'] ?? 5000,
                ),
              );

              if (kDebugMode) {
                print('[TikTok API] Video ${i + 1}/${targetTikTokUrls.length} cargado exitosamente.');
              }
            }
          } else {
            if (kDebugMode) {
              print('[TikTok API Warning] Enlace ${i + 1} rechazado por la API: ${data['msg']}');
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('[TikTok API Error en enlace ${i + 1}]: $e');
        }
      }
    }

    if (posts.isNotEmpty) {
      if (kDebugMode) {
        print('[TikTok API] ¡Proceso terminado! Se cargaron ${posts.length} de ${targetTikTokUrls.length} videos.');
      }
      return posts;
    }

    // Respaldo secundario si la red falla por completo
    if (kDebugMode) {
      print('[TikTok Datasource] Cargando videos de respaldo...');
    }

    return [
      VideoPost(
        caption: 'Video de TikTok: Contenido de tendencia y música',
        videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
        likes: 18400,
        views: 120000,
      ),
      VideoPost(
        caption: 'Video de TikTok: Clip de baile y entretenimiento',
        videoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
        likes: 9300,
        views: 54000,
      ),
    ];
  }

  @override
  Future<List<VideoPost>> getForYouVideosByPage(int page) async => [];

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userID) async => [];
}