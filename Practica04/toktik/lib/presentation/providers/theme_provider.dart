import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/theme/app_season_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_season_override';

  SeasonThemeData _currentTheme = SeasonThemeData.fromSeason(AppSeason.normal);
  AppSeason? _overrideSeason;

  SeasonThemeData get currentTheme => _currentTheme;
  AppSeason? get overrideSeason => _overrideSeason;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Detecta la temporada en base al mes y día actual del dispositivo
  AppSeason _detectSeasonByDate() {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;

    // San Valentín: 1 al 15 de Febrero
    if (month == 2 && day <= 15) {
      return AppSeason.valentines;
    }
    // Halloween: 20 de Octubre al 2 de Noviembre
    if ((month == 10 && day >= 20) || (month == 11 && day <= 2)) {
      return AppSeason.halloween;
    }
    // Navidad: Todo Diciembre
    if (month == 12) {
      return AppSeason.christmas;
    }

    return AppSeason.normal;
  }

  // Carga la preferencia guardada de SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSeason = prefs.getString(_prefKey);

    if (savedSeason != null) {
      _overrideSeason = AppSeason.values.firstWhere(
        (e) => e.name == savedSeason,
        orElse: () => AppSeason.normal,
      );
      _currentTheme = SeasonThemeData.fromSeason(_overrideSeason!);
    } else {
      final detected = _detectSeasonByDate();
      _currentTheme = SeasonThemeData.fromSeason(detected);
    }
    notifyListeners();
  }

  // Cambia manualmente la temporada (Mecanismo de Prueba)
  Future<void> setSeasonTheme(AppSeason? season) async {
    final prefs = await SharedPreferences.getInstance();

    if (season == null) {
      // Regresa a la detección automática por fecha
      _overrideSeason = null;
      await prefs.remove(_prefKey);
      final detected = _detectSeasonByDate();
      _currentTheme = SeasonThemeData.fromSeason(detected);
    } else {
      // Fuerza una temporada específica
      _overrideSeason = season;
      await prefs.setString(_prefKey, season.name);
      _currentTheme = SeasonThemeData.fromSeason(season);
    }

    notifyListeners();
  }
}