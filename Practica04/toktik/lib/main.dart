import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:toktik/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/screens/home/main_feed_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final videoPostRepository = VideoPostsRepositoryImpl(
      videosDatasource: LocalVideoDatasource(),
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
            home: const MainFeedScreen(),
          );
        },
      ),
    );
  }
}