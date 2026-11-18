import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDatasource {

  final String language;
  final Dio dio;

  // Caché de actores por movieId e idioma
  static final Map<String, List<Actor>> _actorsCache = {};

  ActorMovieDbDatasource({this.language = 'es-MX'})
    : dio = Dio(BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {
          'api_key': Environment.theMovieDbKey,
          'language': language
        }
      ));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async{
    final cacheKey = '${movieId}_$language';
    if (_actorsCache.containsKey(cacheKey)) {
      return _actorsCache[cacheKey]!;
    }
    
    final response = await dio.get(
      '/movie/$movieId/credits'
    );

    final castResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = castResponse.cast.map(
      (cast) => ActorMapper.castToEntity(cast)
    ).toList();
    
    _actorsCache[cacheKey] = actors;
    return actors;
  }

}
