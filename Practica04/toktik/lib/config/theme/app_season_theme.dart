import 'package:flutter/material.dart';

enum AppSeason { normal, halloween, christmas, valentines }

class SeasonThemeData {
  final AppSeason season;
  final String name;
  final ThemeData themeData;
  final IconData likeIcon;
  final IconData viewsIcon;
  final Color accentColor;
  final String audioAsset;

  SeasonThemeData({
    required this.season,
    required this.name,
    required this.themeData,
    required this.likeIcon,
    required this.viewsIcon,
    required this.accentColor,
    required this.audioAsset,
  });

  factory SeasonThemeData.fromSeason(AppSeason season) {
    switch (season) {
      case AppSeason.halloween:
        return SeasonThemeData(
          season: AppSeason.halloween,
          name: 'Halloween 🎃',
          accentColor: Colors.orangeAccent,
          likeIcon: Icons.sentiment_very_dissatisfied, // Naranja / Calabaza / Calavera
          viewsIcon: Icons.remove_red_eye_sharp,
          audioAsset: 'assets/audio/halloween_theme.mp3',
          themeData: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF120E16),
            colorScheme: const ColorScheme.dark(
              primary: Colors.orange,
              secondary: Colors.deepOrangeAccent,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
            ),
          ),
        );

      case AppSeason.christmas:
        return SeasonThemeData(
          season: AppSeason.christmas,
          name: 'Navidad 🎄',
          accentColor: Colors.redAccent,
          likeIcon: Icons.card_giftcard,
          viewsIcon: Icons.ac_unit,
          audioAsset: 'assets/audio/christmas_theme.mp3',
          themeData: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF0F1A15),
            colorScheme: const ColorScheme.dark(
              primary: Colors.red,
              secondary: Colors.greenAccent,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        );

      case AppSeason.valentines:
        return SeasonThemeData(
          season: AppSeason.valentines,
          name: 'San Valentín 💘',
          accentColor: Colors.pinkAccent,
          likeIcon: Icons.favorite,
          viewsIcon: Icons.auto_awesome,
          audioAsset: 'assets/audio/valentines_theme.mp3',
          themeData: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF1C0D18),
            colorScheme: const ColorScheme.dark(
              primary: Colors.pink,
              secondary: Colors.pinkAccent,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
            ),
          ),
        );

      case AppSeason.normal:
      default:
        return SeasonThemeData(
          season: AppSeason.normal,
          name: 'Normal 📱',
          accentColor: Colors.red,
          likeIcon: Icons.favorite,
          viewsIcon: Icons.remove_red_eye,
          audioAsset: 'assets/audio/normal_theme.mp3',
          themeData: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            colorScheme: const ColorScheme.dark(
              primary: Colors.red,
              secondary: Colors.white,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
    }
  }
}