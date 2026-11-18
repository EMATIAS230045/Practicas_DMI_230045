import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/locale_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final currentLocale = ref.watch(localeProvider);
    final contentType = ref.watch(contentTypeProvider);

    return Drawer(
      backgroundColor: const Color(0xFF121418),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Encabezado cinemapedia (paleta oscura con acentos cian/turquesa) ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withAlpha(50),
                    const Color(0xFF1E232B),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(color: colors.primary.withAlpha(60), width: 1.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.primary, width: 1.5),
                    ),
                    child: Icon(Icons.movie_outlined, color: colors.primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cinemapedia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        contentType == ContentType.movies
                            ? tr(currentLocale, 'movies')
                            : tr(currentLocale, 'tvSeries'),
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Sección 1: Tipo de contenido (Películas vs. Series) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                tr(currentLocale, 'contentType').toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: colors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SegmentedButton<ContentType>(
                segments: [
                  ButtonSegment<ContentType>(
                    value: ContentType.movies,
                    label: Text(tr(currentLocale, 'movies')),
                    icon: const Icon(Icons.movie_creation_outlined),
                  ),
                  ButtonSegment<ContentType>(
                    value: ContentType.tv,
                    label: Text(tr(currentLocale, 'tvSeries')),
                    icon: const Icon(Icons.tv),
                  ),
                ],
                selected: {contentType},
                onSelectionChanged: (Set<ContentType> newSelection) {
                  ref.read(contentTypeProvider.notifier).state = newSelection.first;
                  Navigator.of(context).pop(); // Cierra el Drawer automáticamente
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return colors.primary.withAlpha(80);
                    }
                    return Colors.transparent;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return colors.primary;
                    }
                    return Colors.white70;
                  }),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.white12, indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // ── Sección 2: Idioma / Región (7 opciones sin bandera duplicada) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                tr(currentLocale, 'languageRegion').toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: colors.primary,
                ),
              ),
            ),
            ...localeOptions.map((opt) {
              final loc = opt['locale'] as Locale;
              final isSelected = (loc == currentLocale);
              // Usamos opt['name'] limpio para no duplicar la bandera del leading
              final cleanName = (opt['name'] ?? opt['label']) as String;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary.withAlpha(35) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: colors.primary.withAlpha(120), width: 1)
                      : null,
                ),
                child: ListTile(
                  dense: true,
                  leading: Text(opt['flag'] as String, style: const TextStyle(fontSize: 22)),
                  title: Text(
                    cleanName,
                    style: TextStyle(
                      color: isSelected ? colors.primary : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Text(
                    opt['apiLang'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? colors.primary : Colors.white38,
                      fontFamily: 'monospace',
                    ),
                  ),
                  onTap: () {
                    ref.read(localeProvider.notifier).state = loc;
                    Navigator.of(context).pop(); // Cierra el Drawer automáticamente
                  },
                ),
              );
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
