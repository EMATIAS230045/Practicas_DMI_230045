import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/presentation/widgets/shared/video_buttons.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final VideoPost video;

  const FullScreenPlayer({
    super.key,
    required this.video,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(widget.video.videoUrl)
      ..setVolume(isMuted ? 0.0 : 1.0)
      ..setLooping(true)
      ..play();

    _initializeVideoPlayerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      controller.setVolume(isMuted ? 0.0 : 1.0);
    });
  }

  void togglePlayPause() {
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar el video:\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        return GestureDetector(
          onTap: togglePlayPause,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              children: [
                // Reproductor de Video
                VideoPlayer(controller),

                // Gradiente inferior
                VideoBackground(
                  stops: const [0.8, 1.0],
                ),

                // Icono de Play gigante en el centro cuando está en PAUSA
                if (!controller.value.isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white70,
                      size: 100,
                    ),
                  ),

                // Descripción del Video (Inferior izquierda)
                Positioned(
                  bottom: 50,
                  left: 20,
                  child: _VideoCaption(caption: widget.video.caption),
                ),

                // Botones de acción (Inferior derecha: Likes, Views, Mute, Disco)
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: VideoButtons(
                    video: widget.video,
                    isMuted: isMuted,
                    onMuteToggle: toggleMute,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SizedBox(
      width: size.width * 0.6,
      child: Text(caption, maxLines: 2, style: titleStyle),
    );
  }
}