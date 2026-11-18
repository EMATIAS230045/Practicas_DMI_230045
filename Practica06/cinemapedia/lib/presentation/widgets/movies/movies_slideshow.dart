import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/locale_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// MoviesSlideshow displays a horizontal carousel of movie/series cards.
///
/// Features:
/// 1. Tarjeta con bordes redondeados y sección inferior integrada con:
///    - "Título en idioma seleccionado" y Título en blanco/negrita.
///    - "Título original ([Código])" y Título original subrayado.
///    - Fila inferior con puntuación ⭐ y badge con bandera + clasificación corta.
///    - Pie discreto: "Clasificación obtenida desde: [País]".
/// 2. Botones circulares oscuros semitransparentes en los bordes para flechas < y >
///    con lógica exacta de 1 clic (anterior/siguiente) y doble clic (primera/última).
class MoviesSlideshow extends StatefulWidget {
  final List<Movie> movies;

  const MoviesSlideshow({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  State<MoviesSlideshow> createState() => _MoviesSlideshowState();
}

class _MoviesSlideshowState extends State<MoviesSlideshow> {
  final SwiperController _controller = SwiperController();

  Timer? _leftClickTimer;
  Timer? _rightClickTimer;
  static const Duration _doubleClickDelay = Duration(milliseconds: 250);

  @override
  void dispose() {
    _leftClickTimer?.cancel();
    _rightClickTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onLeftTap() {
    if (_leftClickTimer?.isActive ?? false) {
      _leftClickTimer?.cancel();
      if (widget.movies.isNotEmpty) {
        _controller.move(0, animation: true);
      }
    } else {
      _leftClickTimer = Timer(_doubleClickDelay, () {
        _controller.previous(animation: true);
      });
    }
  }

  void _onRightTap() {
    if (_rightClickTimer?.isActive ?? false) {
      _rightClickTimer?.cancel();
      if (widget.movies.isNotEmpty) {
        _controller.move(widget.movies.length - 1, animation: true);
      }
    } else {
      _rightClickTimer = Timer(_doubleClickDelay, () {
        _controller.next(animation: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 320,
          width: double.infinity,
          child: Swiper(
            controller: _controller,
            viewportFraction: 0.85,
            scale: 0.92,
            autoplay: true,
            pagination: SwiperPagination(
              margin: const EdgeInsets.only(top: 0),
              builder: DotSwiperPaginationBuilder(
                activeColor: colors.primary,
                color: colors.secondary,
              ),
            ),
            itemCount: widget.movies.length,
            itemBuilder: (context, index) => _Slide(movie: widget.movies[index]),
          ),
        ),
        // Botón circular izquierdo para flecha <
        Positioned(
          left: 12,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onLeftTap,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withAlpha(160),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Botón circular derecho para flecha >
        Positioned(
          right: 12,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onRightTap,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withAlpha(160),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Slide extends ConsumerWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final locale = ref.watch(localeProvider);
    final contentType = ref.watch(contentTypeProvider);
    final isTv = (contentType == ContentType.tv);

    final flag = getFlag(locale);
    final countryCode = getCountryCode(locale);
    final countryName = getCountryName(locale);
    final shortClassification = getShortClassification(locale, isTv: isTv);

    final decoration = BoxDecoration(
      color: const Color(0xFF161A20),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 10,
          offset: Offset(0, 10),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            onTap: () => context.push('/home/0/movie/${movie.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Parte Superior: Imagen de Fondo con Shimmer ──
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SmoothNetworkImage(
                        imageUrl: movie.backdropPath,
                        fit: BoxFit.cover,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      // Sutil degradado para fundir la imagen con la sección de información
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xFF161A20)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Parte Inferior Sólida: Información estructurada ──
                Container(
                  color: const Color(0xFF161A20),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. "Título en idioma seleccionado" y Título principal
                      Text(
                        tr(locale, 'titleInSelectedLanguage'),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 5),

                      // 2. "Título original ([Código])" y Título original subrayado
                      Text(
                        '${tr(locale, 'originalTitle')} (${movie.originalLanguage.toUpperCase()})',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        movie.originalTitle.isNotEmpty ? movie.originalTitle : movie.title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white30,
                          decorationThickness: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // 3. Fila inferior: Estrella + Puntaje (izq) y Badge Bandera + Clasificación (der)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Izquierda: Estrella y puntaje numérico
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          // Derecha: Badge redondeado con bandera + código + clasificación corta
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.primary.withAlpha(45),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colors.primary.withAlpha(120),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(flag, style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 4),
                                Text(
                                  '$countryCode · $shortClassification',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // 4. Pie de tarjeta discreto
                      Text(
                        '${tr(locale, 'classificationFrom')} $countryName',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
