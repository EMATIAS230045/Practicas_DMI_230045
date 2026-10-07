import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/domain/entities/video_post.dart';
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

    return Column(
      children: [
        // Likes
        _CustomIconButton(
          value: video.likes,
          iconData: seasonTheme.likeIcon,
          iconColor: seasonTheme.accentColor,
        ),
        const SizedBox(height: 15),

        // Vistas
        _CustomIconButton(
          value: video.views,
          iconData: seasonTheme.viewsIcon,
          iconColor: Colors.white,
        ),
        const SizedBox(height: 15),

        // Botón Mute / Unmute
        IconButton(
          onPressed: onMuteToggle,
          icon: Icon(
            isMuted ? Icons.volume_off : Icons.volume_up,
            color: isMuted ? Colors.redAccent : Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 15),

        // Disco giratorio
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

  const _CustomIconButton({
    required this.value, 
    required this.iconData, 
    Color? iconColor,
  }) : color = iconColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {}, 
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