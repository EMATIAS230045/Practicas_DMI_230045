import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/feed_provider.dart';
import 'package:toktik/presentation/widgets/shared/theme_selector_dialog.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  late PageController _horizontalPageController;

  @override
  void initState() {
    super.initState();
    _horizontalPageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _horizontalPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = context.watch<FeedProvider>();

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _horizontalPageController,
            onPageChanged: (index) => feedProvider.setActiveTab(index),
            children: [
              feedProvider.isDiscoverLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : VideoScrollableView(videos: feedProvider.discoverVideos),
              feedProvider.isForYouLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : VideoScrollableView(videos: feedProvider.forYouVideos),
              feedProvider.isFavoritesLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : VideoScrollableView(videos: feedProvider.favoriteVideos),
            ],
          ),

          // Header con Pestañas y Botón de Prueba de Temporadas
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón para abrir el selector de temporadas
                IconButton(
                  icon: const Icon(Icons.palette_outlined, color: Colors.white, size: 28),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ThemeSelectorDialog(),
                    );
                  },
                ),
                Row(
                  children: [
                    _TabButton(
                      title: 'Descubrir',
                      isActive: feedProvider.activeTabIndex == 0,
                      onTap: () => _horizontalPageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut),
                    ),
                    const SizedBox(width: 15),
                    _TabButton(
                      title: 'Para ti',
                      isActive: feedProvider.activeTabIndex == 1,
                      onTap: () => _horizontalPageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut),
                    ),
                    const SizedBox(width: 15),
                    _TabButton(
                      title: 'Favoritos',
                      isActive: feedProvider.activeTabIndex == 2,
                      onTap: () => _horizontalPageController.animateToPage(2,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut),
                    ),
                  ],
                ),
                const SizedBox(width: 28), // Balance visual
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(isActive ? 1.0 : 0.5),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: isActive ? 17 : 15,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 2,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}