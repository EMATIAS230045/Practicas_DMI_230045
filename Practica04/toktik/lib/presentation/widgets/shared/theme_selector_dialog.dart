// lib/presentation/widgets/shared/theme_selector_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/services/app_task_service.dart';
import 'package:toktik/config/theme/app_season_theme.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';

class ThemeSelectorDialog extends StatelessWidget {
  const ThemeSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isAutomatic = themeProvider.selectedMode == ThemeModeOption.automatic;
    final isCustomDate = themeProvider.selectedMode == ThemeModeOption.customDate;

    return AlertDialog(
      title: const Text('Probar Temporada (Modo Pruebas)'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Modo Automático (Fecha Real del dispositivo)
            ListTile(
              title: const Text('Modo Automático (Fecha Actual)'),
              subtitle: Text(
                'Hoy: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              leading: Icon(
                isAutomatic ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isAutomatic ? Theme.of(context).primaryColor : Colors.grey,
              ),
              onTap: () async {
                await themeProvider.setAutomaticMode();
                await AppTaskService.closeAndRemoveFromRecents();
              },
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'El icono de inicio se actualiza al cerrar la app desde recientes.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const Divider(),

            // 2. Simular por Fecha (DatePicker / Calendario)
            ListTile(
              title: const Text('Simular por Fecha 📅'),
              subtitle: Text(
                isCustomDate && themeProvider.customDate != null
                    ? 'Seleccionada: ${themeProvider.customDate!.day}/${themeProvider.customDate!.month}/${themeProvider.customDate!.year}'
                    : 'Elegir día en el calendario',
                style: TextStyle(
                  fontSize: 12,
                  color: isCustomDate ? Colors.amber : Colors.grey,
                ),
              ),
              leading: Icon(
                Icons.calendar_month_rounded,
                color: isCustomDate ? Colors.amber : Colors.grey,
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: themeProvider.customDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark(),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  await themeProvider.setCustomDate(pickedDate);
                  await AppTaskService.closeAndRemoveFromRecents();
                }
              },
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
              child: Text(
                'Forzar Temporada Directa:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            // 3. Mapeo dinámico de temporadas manuales
            ...AppSeason.values.map((season) {
              final seasonData = SeasonThemeData.fromSeason(season);
              final isSelected = themeProvider.selectedMode == ThemeModeOption.manual &&
                  themeProvider.overrideSeason == season;

              return ListTile(
                title: Text(seasonData.name),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                ),
                onTap: () async {
                  await themeProvider.setSeasonTheme(season);
                  await AppTaskService.closeAndRemoveFromRecents();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
