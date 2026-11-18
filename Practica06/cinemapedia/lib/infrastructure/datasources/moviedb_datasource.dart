import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/models/models.dart';
import 'package:cinemapedia/infrastructure/mappers/mappers.dart';

import 'package:cinemapedia/domain/entities/entities.dart';

class MoviedbDatasource extends MoviesDatasource {

  final String language;
  final bool isTv;
  final Dio dio;

  // ── Caché local en memoria por endpoint e idioma ──
  static final Map<String, List<Movie>> _moviesListCache = {};
  static final Map<String, Movie> _movieDetailCache = {};
  static final Map<String, List<Movie>> _similarMoviesCache = {};
  static final Map<String, List<Video>> _videosCache = {};

  MoviedbDatasource({this.language = 'es-MX', this.isTv = false})
    : dio = Dio(BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {
          'api_key': Environment.theMovieDbKey,
          'language': language
        }
      ));

  List<Movie> _jsonToMovies( Map<String,dynamic> json ) {
    final results = json['results'] as List<dynamic>? ?? [];

    final List<Movie> movies = results
        .where((item) => (item['poster_path'] != null && item['poster_path'] != ''))
        .map((item) {
          // Adaptador para soportar respuesta de TV (/tv/...) o Movies (/movie/...)
          final title = (item['title'] ?? item['name'] ?? 'No Title').toString();
          final originalTitle = (item['original_title'] ?? item['original_name'] ?? '').toString();
          final releaseStr = (item['release_date'] ?? item['first_air_date'] ?? '').toString();
          DateTime? releaseDate;
          if (releaseStr.isNotEmpty) {
            try {
              releaseDate = DateTime.parse(releaseStr);
            } catch (_) {}
          }

          final moviedb = MovieMovieDB(
            adult: item['adult'] ?? false,
            backdropPath: item['backdrop_path'] ?? item['poster_path'] ?? '',
            genreIds: (item['genre_ids'] as List<dynamic>? ?? []).map((e) => (e as num).toInt()).toList(),
            id: item['id'],
            originalLanguage: item['original_language'] ?? '',
            originalTitle: originalTitle,
            overview: item['overview'] ?? '',
            popularity: (item['popularity'] as num?)?.toDouble() ?? 0.0,
            posterPath: item['poster_path'] ?? '',
            releaseDate: releaseDate,
            title: title,
            video: item['video'] ?? false,
            voteAverage: (item['vote_average'] as num?)?.toDouble() ?? 0.0,
            voteCount: item['vote_count'] ?? 0,
          );

          return MovieMapper.movieDBToEntity(moviedb);
        }).toList();

    return movies;
  }

  // Pre-carga los datos de un idioma específico en segundo plano (para películas y series)
  static Future<void> preloadLanguage(String lang) async {
    final movieDs = MoviedbDatasource(language: lang, isTv: false);
    final tvDs = MoviedbDatasource(language: lang, isTv: true);

    await Future.wait([
      movieDs.getNowPlaying(page: 1),
      movieDs.getPopular(page: 1),
      movieDs.getUpcoming(page: 1),
      movieDs.getTopRated(page: 1),
      tvDs.getNowPlaying(page: 1),
      tvDs.getPopular(page: 1),
      tvDs.getUpcoming(page: 1),
      tvDs.getTopRated(page: 1),
    ]);
  }

  // Pre-carga los 7 idiomas disponibles tanto para Películas como para Series
  static void preloadAllLanguages() {
    const languages = [
      'en-US',
      'es-MX',
      'es-CO',
      'de-DE',
      'zh-CN',
      'ar-EG',
      'ru-RU',
    ];
    for (final lang in languages) {
      preloadLanguage(lang);
    }
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final endpoint = isTv ? '/tv/on_the_air' : '/movie/now_playing';
    final cacheKey = '${endpoint}_${language}_$page';
    if (_moviesListCache.containsKey(cacheKey)) {
      return _moviesListCache[cacheKey]!;
    }

    final response = await dio.get(endpoint, 
      queryParameters: { 'page': page }
    );
    
    final movies = _jsonToMovies(response.data);
    _moviesListCache[cacheKey] = movies;
    return movies;
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final endpoint = isTv ? '/tv/popular' : '/movie/popular';
    final cacheKey = '${endpoint}_${language}_$page';
    if (_moviesListCache.containsKey(cacheKey)) {
      return _moviesListCache[cacheKey]!;
    }

    final response = await dio.get(endpoint, 
      queryParameters: { 'page': page }
    );

    final movies = _jsonToMovies(response.data);
    _moviesListCache[cacheKey] = movies;
    return movies;
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final endpoint = isTv ? '/tv/top_rated' : '/movie/top_rated';
    final cacheKey = '${endpoint}_${language}_$page';
    if (_moviesListCache.containsKey(cacheKey)) {
      return _moviesListCache[cacheKey]!;
    }

    final response = await dio.get(endpoint, 
      queryParameters: { 'page': page }
    );

    final movies = _jsonToMovies(response.data);
    _moviesListCache[cacheKey] = movies;
    return movies;
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final endpoint = isTv ? '/tv/airing_today' : '/movie/upcoming';
    final cacheKey = '${endpoint}_${language}_$page';
    if (_moviesListCache.containsKey(cacheKey)) {
      return _moviesListCache[cacheKey]!;
    }

    final response = await dio.get(endpoint, 
      queryParameters: { 'page': page }
    );

    final movies = _jsonToMovies(response.data);
    _moviesListCache[cacheKey] = movies;
    return movies;
  }

  @override
  Future<Movie> getMovieById( String id ) async {
    final endpoint = isTv ? '/tv/$id' : '/movie/$id';
    final cacheKey = '${endpoint}_$language';
    if (_movieDetailCache.containsKey(cacheKey)) {
      return _movieDetailCache[cacheKey]!;
    }

    // Si no está en caché con el endpoint actual, intentamos obtenerlo
    Response response;
    try {
      response = await dio.get(endpoint);
    } catch (_) {
      // Si falla como movie o tv, intenta el contrario como fallback
      final fallbackEndpoint = isTv ? '/movie/$id' : '/tv/$id';
      response = await dio.get(fallbackEndpoint);
    }

    if ( response.statusCode != 200 ) throw Exception('Resource with id: $id not found');

    final data = response.data;
    // Si viene de /tv/, adaptamos los nombres de campos (name -> title, first_air_date -> release_date)
    final title = (data['title'] ?? data['name'] ?? 'No Title').toString();
    final originalTitle = (data['original_title'] ?? data['original_name'] ?? '').toString();
    final releaseStr = (data['release_date'] ?? data['first_air_date'] ?? '').toString();
    DateTime releaseDate = DateTime.now();
    if (releaseStr.isNotEmpty) {
      try {
        releaseDate = DateTime.parse(releaseStr);
      } catch (_) {}
    }

    final genresList = (data['genres'] as List<dynamic>? ?? []).map((x) => Genre.fromJson(x)).toList();

    final movieDetails = MovieDetails(
      adult: data['adult'] ?? false,
      backdropPath: data['backdrop_path'] ?? data['poster_path'] ?? '',
      belongsToCollection: data['belongs_to_collection'] == null ? null : BelongsToCollection.fromJson(data['belongs_to_collection']),
      budget: data['budget'] ?? 0,
      genres: genresList,
      homepage: data['homepage'] ?? '',
      id: data['id'],
      imdbId: data['imdb_id'],
      originalLanguage: data['original_language'] ?? '',
      originalTitle: originalTitle,
      overview: data['overview'] ?? '',
      popularity: (data['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: data['poster_path'] ?? '',
      productionCompanies: (data['production_companies'] as List<dynamic>? ?? []).map((x) => ProductionCompany.fromJson(x)).toList(),
      productionCountries: (data['production_countries'] as List<dynamic>? ?? []).map((x) => ProductionCountry.fromJson(x)).toList(),
      releaseDate: releaseDate,
      revenue: data['revenue'] ?? 0,
      runtime: data['runtime'] ?? (data['episode_run_time'] is List && (data['episode_run_time'] as List).isNotEmpty ? (data['episode_run_time'][0] ?? 0) : 0),
      spokenLanguages: (data['spoken_languages'] as List<dynamic>? ?? []).map((x) => SpokenLanguage.fromJson(x)).toList(),
      status: data['status'] ?? '',
      tagline: data['tagline'] ?? '',
      title: title,
      video: data['video'] ?? false,
      voteAverage: (data['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: data['vote_count'] ?? 0,
    );

    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
    _movieDetailCache[cacheKey] = movie;
    return movie;
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) async{
    if ( query.isEmpty ) return [];

    final endpoint = isTv ? '/search/tv' : '/search/movie';
    final response = await dio.get(endpoint, 
      queryParameters: { 'query': query }
    );

    return _jsonToMovies(response.data);    
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final endpoint = isTv ? '/tv/$movieId/similar' : '/movie/$movieId/similar';
    final cacheKey = '${endpoint}_$language';
    if (_similarMoviesCache.containsKey(cacheKey)) {
      return _similarMoviesCache[cacheKey]!;
    }

    try {
      final response = await dio.get(endpoint);
      final movies = _jsonToMovies(response.data);
      _similarMoviesCache[cacheKey] = movies;
      return movies;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final endpoint = isTv ? '/tv/$movieId/videos' : '/movie/$movieId/videos';
    final cacheKey = '${endpoint}_$language';
    if (_videosCache.containsKey(cacheKey)) {
      return _videosCache[cacheKey]!;
    }

    try {
      final response = await dio.get(endpoint);
      final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
      final videos = <Video>[];

      for (final moviedbVideo in moviedbVideosReponse.results) {
        if ( moviedbVideo.site == 'YouTube' ) {
          final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
          videos.add(video);
        }
      }

      _videosCache[cacheKey] = videos;
      return videos;
    } catch (_) {
      return [];
    }
  }

}
