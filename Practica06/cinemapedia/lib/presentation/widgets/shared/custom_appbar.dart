import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/domain/entities/movie.dart';

import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final contentType = ref.watch(contentTypeProvider);
    final currentLocale = ref.watch(localeProvider);

    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon( Icons.movie_outlined, color: colors.primary, size: 22 ),
          const SizedBox( width: 6 ),
          const Text(
            'Cinemapedia', 
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: colors.primary.withAlpha(35),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.primary.withAlpha(90), width: 0.8),
            ),
            child: Text(
              contentType == ContentType.movies
                  ? tr(currentLocale, 'movies')
                  : tr(currentLocale, 'tvSeries'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colors.primary,
                height: 1.1,
              ),
            ),
          ),

          const Spacer(),

          // Botón de búsqueda
          IconButton(
            iconSize: 22,
            splashRadius: 20,
            onPressed: () {

              final searchedMovies = ref.read( searchedMoviesProvider );
              final searchQuery = ref.read(searchQueryProvider);
              
              showSearch<Movie?>(
                query: searchQuery,
                context: context, 
                delegate: SearchMovieDelegate(
                  initialMovies: searchedMovies,
                  searchMovies: ref.read( searchedMoviesProvider.notifier ).searchMoviesByQuery
                )
              ).then((movie) {
                if ( movie == null || !context.mounted ) return;

                context.push('/home/0/movie/${ movie.id }');
              });

            }, 
            icon: const Icon(Icons.search)
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
