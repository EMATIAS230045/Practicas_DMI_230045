// lib/presentation/providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktik/config/theme/app_season_theme.dart';

enum ThemeModeOption { automatic, customDate, manual }

class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_season_override';
  static const String _datePrefKey = 'simulated_custom_date';

  SeasonThemeData _currentTheme = SeasonThemeData.fromSeason(AppSeason.normal);
  AppSeason? _overrideSeason;
  DateTime? _customDate;

  SeasonThemeData get currentTheme => _currentTheme;
  AppSeason? get overrideSeason => _overrideSeason;
  DateTime? get customDate => _customDate;

  ThemeModeOption get selectedMode {
    if (_overrideSeason != null) return ThemeModeOption.manual;
    if (_customDate != null) return ThemeModeOption.customDate;
    return ThemeModeOption.automatic;
  }

  ThemeProvider() {
    _loadThemePreference();
  }

  // Detecta la temporada evaluando cualquier fecha dada (real o simulada)
  AppSeason detectSeasonFromDate(DateTime date) {
    final month = date.month;
    final day = date.day;

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

  // Carga las preferencias de SharedPreferences al iniciar la app
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSeason = prefs.getString(_prefKey);
    final savedDateStr = prefs.getString(_datePrefKey);

    if (savedSeason != null) {
      _overrideSeason = AppSeason.values.firstWhere(
        (e) => e.name == savedSeason,
        orElse: () => AppSeason.normal,
      );
      _currentTheme = SeasonThemeData.fromSeason(_overrideSeason!);
      await _updateAppLauncherIcon(_overrideSeason!);
    } else if (savedDateStr != null) {
      _customDate = DateTime.tryParse(savedDateStr);
      if (_customDate != null) {
        final season = detectSeasonFromDate(_customDate!);
        _currentTheme = SeasonThemeData.fromSeason(season);
        await _updateAppLauncherIcon(season);
      } else {
        await _updateThemeByRealDate();
      }
    } else {
      await _updateThemeByRealDate();
    }
    notifyListeners();
  }

  Future<void> _updateThemeByRealDate() async {
    final detected = detectSeasonFromDate(DateTime.now());
    _currentTheme = SeasonThemeData.fromSeason(detected);
    await _updateAppLauncherIcon(detected);
  }

  // 1. Activa el Modo Automático (Fecha Actual)
  Future<void> setAutomaticMode() async {
    final prefs = await SharedPreferences.getInstance();
    _overrideSeason = null;
    _customDate = null;
    await prefs.remove(_prefKey);
    await prefs.remove(_datePrefKey);

    await _updateThemeByRealDate();
    notifyListeners();
  }

  // 2. Activa el Modo Simulación por Fecha seleccionada
  Future<void> setCustomDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    _overrideSeason = null;
    _customDate = date;

    await prefs.remove(_prefKey);
    await prefs.setString(_datePrefKey, date.toIso8601String());

    final season = detectSeasonFromDate(date);
    _currentTheme = SeasonThemeData.fromSeason(season);
    await _updateAppLauncherIcon(season);
    notifyListeners();
  }

  // 3. Activa el Modo Manual (Forzar temporada)
  Future<void> setSeasonTheme(AppSeason? season) async {
    final prefs = await SharedPreferences.getInstance();
    _customDate = null;
    await prefs.remove(_datePrefKey);

    if (season == null) {
      await setAutomaticMode();
      return;
    }

    _overrideSeason = season;
    await prefs.setString(_prefKey, season.name);
    _currentTheme = SeasonThemeData.fromSeason(season);
    await _updateAppLauncherIcon(season);

    notifyListeners();
  }

  // Método seguro para actualizar el icono del escritorio del celular
  Future<void> _updateAppLauncherIcon(AppSeason season) async {
    try {
      final supports = await FlutterDynamicIconPlus.supportsAlternateIcons;
      debugPrint('¿Soporta iconos alternativos?: $supports');
      if (!supports) return;

      // En Android los nombres deben coincidir con los activity-alias del
      // manifiesto. El valor null restaura el alias especial .DEFAULT.
      String? iconAliasName;
      switch (season) {
        case AppSeason.halloween:
          iconAliasName = 'halloween';
          break;
        case AppSeason.christmas:
          iconAliasName = 'christmas';
          break;
        case AppSeason.valentines:
          iconAliasName = 'valentines';
          break;
        case AppSeason.normal:
          iconAliasName = null;
          break;
      }

      final currentIcon = await FlutterDynamicIconPlus.alternateIconName;
      debugPrint('Icono actual en sistema: $currentIcon | Solicitado: $iconAliasName');

      final isRequestedIconActive = iconAliasName == null
          ? currentIcon?.endsWith('.DEFAULT') ?? false
          : currentIcon?.endsWith('.$iconAliasName') ?? false;
      if (isRequestedIconActive) {
        debugPrint('El icono solicitado ya es el activo. Se omite cambio.');
        return;
      }

      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: iconAliasName,
      );
      debugPrint('¡Icono cambiado con éxito a: $iconAliasName!');
    } catch (e) {
      debugPrint('Error al cambiar el icono dinámico: $e');
    }
  }
}
