import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:cinemapedia/presentation/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Este repositorio se actualiza con el idioma seleccionado
final actorsRepositoryProvider = Provider((ref) {
  final locale = ref.watch(localeProvider);
  final apiLang = getApiLanguage(locale);
  return ActorRepositoryImpl( ActorMovieDbDatasource(language: apiLang) );
});
