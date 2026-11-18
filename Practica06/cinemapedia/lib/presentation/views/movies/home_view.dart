import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';


class HomeView extends ConsumerStatefulWidget {
  const HomeView({ super.key });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    // Pre-carga en segundo plano los 7 idiomas para respuesta instantánea (0 ms)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MoviedbDatasource.preloadAllLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final initialLoading = ref.watch(initialLoadingProvider);
    if ( initialLoading ) return const FullScreenLoader();
    
    final slideShowMovies = ref.watch( moviesSlideshowProvider );
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );
    final locale = ref.watch( localeProvider );
    final contentType = ref.watch( contentTypeProvider );
    final isTv = (contentType == ContentType.tv);

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          toolbarHeight: 60,
          titleSpacing: 0,
          title: CustomAppbar(),
        ),


        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) {
              return Column(
                  children: [
              
                    MoviesSlideshow(movies: slideShowMovies ),
              
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: isTv ? tr(locale, 'onTheAir') : tr(locale, 'inTheaters'),
                      subTitle: tr(locale, 'monday20'),
                      loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
                    ),
              
                    MovieHorizontalListview(
                      movies: upcomingMovies,
                      title: isTv ? tr(locale, 'airingToday') : tr(locale, 'upcoming'),
                      subTitle: tr(locale, 'thisMonth'),
                      loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage()
                    ),
              
                    MovieHorizontalListview(
                      movies: topRatedMovies,
                      title: tr(locale, 'topRated'),
                      subTitle: tr(locale, 'allTime'),
                      loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage()
                    ),

                    const SizedBox( height: 10 ),
              
                  ],
                );
          },
          childCount: 1
        )),

      ]
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
