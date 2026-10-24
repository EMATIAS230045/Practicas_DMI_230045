import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/app_season_theme.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/screens/home/main_feed_screen.dart';

class SeasonalWelcomeScreen extends StatefulWidget {
  const SeasonalWelcomeScreen({super.key});

  @override
  State<SeasonalWelcomeScreen> createState() => _SeasonalWelcomeScreenState();
}

class _SeasonalWelcomeScreenState extends State<SeasonalWelcomeScreen> {
  Timer? _timer;
  AudioPlayer? _audioPlayer;
  AppSeason? _startedSeason;

  Future<void> _startSeasonalWelcome(SeasonThemeData season) async {
    if (_startedSeason != null) return;
    _startedSeason = season.season;

    final seconds = season.season == AppSeason.halloween ? 8 : 15;
    _timer = Timer(Duration(seconds: seconds), _openFeed);
    _audioPlayer = AudioPlayer();

    try {
      await _audioPlayer!.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer!.play(AssetSource(season.audioAsset), volume: 0.7);
    } catch (error) {
      debugPrint('No se pudo reproducir el audio de inicio: $error');
    }
  }

  void _openFeed() {
    if (!mounted) return;
    unawaited(_audioPlayer?.stop() ?? Future<void>.value());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainFeedScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_audioPlayer?.dispose() ?? Future<void>.value());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final season = themeProvider.currentTheme;

    if (themeProvider.isInitialized && _startedSeason == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startSeasonalWelcome(season);
      });
    }

    return Scaffold(
      backgroundColor: season.themeData.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      season.accentColor.withValues(alpha: 0.34),
                      season.themeData.scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: season.accentColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: season.accentColor.withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Image.asset(season.logoAsset, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Bienvenido a TokTik',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    season.name,
                    style: TextStyle(
                      color: season.accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    themeProvider.isInitialized
                        ? 'Preparando tu experiencia...'
                        : 'Cargando temporada...',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: season.accentColor,
                      strokeWidth: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
