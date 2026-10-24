// lib/presentation/widgets/shared/video_buttons.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';

class VideoButtons extends StatelessWidget {
  final VideoPost video;
  final bool isMuted;
  final VoidCallback onMuteToggle;

  const VideoButtons({
    super.key, 
    required this.video,
    required this.isMuted,
    required this.onMuteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final seasonTheme = context.watch<ThemeProvider>().currentTheme;
    final feedProvider = context.watch<FeedProvider>();

    // Estado en tiempo real derivado de LocalStorage / FeedProvider
    final isLiked = feedProvider.isVideoLiked(video.videoUrl);
    final likesCount = feedProvider.getVideoLikes(video.videoUrl, video.likes);
    final isFavorite = feedProvider.isVideoFavorite(video.videoUrl);

    return Column(
      children: [
        // 1. Botón de Like con toggle interactivo y tema dinámico
        _CustomIconButton(
          value: likesCount,
          iconData: isLiked ? seasonTheme.likeIcon : Icons.favorite_border,
          iconColor: isLiked ? seasonTheme.accentColor : Colors.white,
          onPressed: () => feedProvider.toggleLike(video),
        ),
        const SizedBox(height: 15),

        // 2. Botón de Favorito / Guardado
        _CustomIconButton(
          value: isFavorite ? 1 : 0,
          iconData: isFavorite ? Icons.bookmark : Icons.bookmark_border,
          iconColor: isFavorite ? Colors.amber : Colors.white,
          onPressed: () => feedProvider.toggleFavorite(video),
        ),
        const SizedBox(height: 15),

        // 3. Vistas
        _CustomIconButton(
          value: video.views,
          iconData: seasonTheme.viewsIcon,
          iconColor: Colors.white,
        ),
        const SizedBox(height: 15),

        // 4. Mute / Unmute
        IconButton(
          onPressed: onMuteToggle,
          icon: Icon(
            isMuted ? Icons.volume_off : Icons.volume_up,
            color: isMuted ? Colors.redAccent : Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 15),

        // 5. Disco giratorio
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: _CustomIconButton(
            value: 0,
            iconData: Icons.play_circle_outline,
            iconColor: seasonTheme.accentColor,
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final Color? color;
  final VoidCallback? onPressed;

  const _CustomIconButton({
    required this.value, 
    required this.iconData, 
    Color? iconColor,
    this.onPressed,
  }) : color = iconColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed ?? () {}, 
          icon: Icon(
            iconData,
            color: color,
            size: 30,
          ),
        ),
        if (value > 0)
          Text(
            HumanFormats.humanReadbleNumber(value.toDouble()),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}