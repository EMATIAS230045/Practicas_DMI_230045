import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/presentation/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';

// Este repositorio se actualiza cuando cambia el locale o el tipo de contenido (Películas / Series)
final movieRepositoryProvider = Provider((ref) {
  final locale = ref.watch(localeProvider);
  final contentType = ref.watch(contentTypeProvider);
  final apiLang = getApiLanguage(locale);
  final isTv = (contentType == ContentType.tv);

  return MovieRepositoryImpl(
    MoviedbDatasource(language: apiLang, isTv: isTv)
  );
});
