import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/theme/app_season_theme.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';

class ThemeSelectorDialog extends StatelessWidget {
  const ThemeSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AlertDialog(
      title: const Text('Probar Temporada (Modo Pruebas)'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Modo Automático (Fecha Actual)'),
            leading: Radio<AppSeason?>(
              value: null,
              groupValue: themeProvider.overrideSeason,
              onChanged: (value) {
                themeProvider.setSeasonTheme(null);
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(),
          ...AppSeason.values.map((season) {
            final seasonData = SeasonThemeData.fromSeason(season);
            return ListTile(
              title: Text(seasonData.name),
              leading: Radio<AppSeason?>(
                value: season,
                groupValue: themeProvider.overrideSeason,
                onChanged: (value) {
                  themeProvider.setSeasonTheme(season);
                  Navigator.pop(context);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}