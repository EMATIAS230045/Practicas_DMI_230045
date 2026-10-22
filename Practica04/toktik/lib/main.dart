// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:toktik/infrastructure/datasources/combined_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/giphy_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/pixabay_video_datasource_impl.dart';
import 'package:toktik/infrastructure/datasources/tiktok_video_datasource_impl.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/screens/startup/seasonal_welcome_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final videoPostRepository = VideoPostsRepositoryImpl(
      videosDatasource: CombinedVideoDatasourceImpl(
        localDatasource: LocalVideoDatasource(),
        pixabayDatasource: PixabayVideoDatasource(),
        giphyDatasource: GiphyVideoDatasource(),
        tiktokDatasource: TikTokVideoDatasourceImpl(
          client: http.Client(),
          apiKey: 'c16e56a283mshd6565a3735a8936p1eaef3jsnfb477f1374d2',
        ),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => FeedProvider(videosRepository: videoPostRepository)
            ..loadInitialFeeds(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'TokTik',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme.themeData,
            home: const SeasonalWelcomeScreen(),
          );
        },
      ),
    );
  }
}
