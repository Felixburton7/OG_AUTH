import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/app/app_theme.dart';
import 'package:panna_app/core/router/navigation/nav_drawer_navigator/navigation_drawer.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';
import 'package:panna_app/core/services/widgets/screen_tracker.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';
import 'package:panna_app/features/articles/presentation/bloc/articles/articles_bloc.dart';

class ArticlesHome extends StatefulWidget {
  const ArticlesHome({Key? key}) : super(key: key);

  @override
  _ArticlesHomeState createState() => _ArticlesHomeState();
}

class _ArticlesHomeState extends State<ArticlesHome> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesBloc>().add(FetchArticles()); // Loads articles
  }

  @override
  Widget build(BuildContext context) {
    final String logoPath = Theme.of(context).brightness == Brightness.light
        ? AppThemeAssets.lightLogo
        : AppThemeAssets.darkLogo;

    return ScreenTracker(
      screenName: 'ArticlesHome',
      child: Scaffold(
        drawer: const NavDrawer(),
        body: BlocBuilder<ArticlesBloc, ArticlesState>(
          builder: (context, state) {
            if (state is ArticlesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ArticlesError) {
              return Center(child: Text(state.message));
            } else if (state is ArticlesLoaded) {
              // Separate your different article categories
              final List<ArticleDetailEntity> topStories = state.articles
                  .where((articleDetail) => articleDetail.article.topStory!)
                  .toList();
              final List<ArticleDetailEntity> shortStories = state.articles
                  .where((articleDetail) => articleDetail.article.shortStory!)
                  .toList();

              // NEW: Live opinions
              final List<ArticleDetailEntity> liveOpinions = state.articles
                  .where((articleDetail) => articleDetail.article.liveOpinion!)
                  .toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 70.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Theme.of(context).canvasColor,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    title: Image.asset(
                      logoPath,
                      fit: BoxFit.contain,
                      height: 50,
                      width: 100,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Center(
                          child: Text(
                            'Could not load logo',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // Top Story Section
                        if (topStories.isNotEmpty) ...[
                          _buildTopStory(context, topStories.first),
                          const SizedBox(height: 20),
                        ],

                        // Thick divider
                        Container(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          height: 5.0,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 20),

                        // Short Stories Section ("For You")
                        if (shortStories.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            child: Text(
                              'For You',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          ..._buildShortStoriesList(context, shortStories),
                        ],

                        // NEW Live Opinions Section (Named "Headlines")
                        if (liveOpinions.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.0),
                            child: Text(
                              'Headlines',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._buildLiveOpinionList(liveOpinions),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildTopStory(
      BuildContext context, ArticleDetailEntity articleDetail) {
    return GestureDetector(
      onTap: () {
        // Log event for top story tap
        getIt<FirebaseAnalyticsService>()
            .logEvent('top_story_tap', parameters: {
          'title': articleDetail.article.title,
        });
        context.push(Routes.articleDetails.path, extra: articleDetail);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image
            SizedBox(
              width: double.infinity,
              child: articleDetail.article.imageUrl != null
                  ? Image.network(
                      articleDetail.article.imageUrl!,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Could not load image',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    )
                  : Container(height: 200, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              articleDetail.article.title ?? 'No Title',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'By ${articleDetail.article.authorName ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.thumb_up, size: 14, color: Colors.grey),
                const SizedBox(width: 3),
                Text(
                  '${articleDetail.likes?.length ?? 0}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildShortStoriesList(
      BuildContext context, List<ArticleDetailEntity> shortStories) {
    final List<Widget> cards = [];

    for (int i = 0; i < shortStories.length; i++) {
      cards.add(_buildShortStoryCard(context, articleDetail: shortStories[i]));

      // Thin divider after each card (except last)
      if (i < shortStories.length - 1) {
        cards.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width * 0.95,
                  color: const Color.fromARGB(255, 213, 213, 213),
                ),
              ),
            ],
          ),
        );
      }
    }

    return cards;
  }

  Widget _buildShortStoryCard(BuildContext context,
      {required ArticleDetailEntity articleDetail}) {
    final article = articleDetail.article;
    final imageUrl = article.imageUrl;

    bool isValidUrl(String? url) {
      if (url == null || url.isEmpty) return false;
      final lower = url.toLowerCase();
      return lower.startsWith('http://') || lower.startsWith('https://');
    }

    return GestureDetector(
      onTap: () {
        getIt<FirebaseAnalyticsService>()
            .logEvent('short_story_tap', parameters: {
          'title': article.title,
          'author': article.authorId,
        });
        context.push(Routes.articleDetails.path, extra: articleDetail);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 110,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title (truncated if too long)
                    Text(
                      article.title ?? 'No Title',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    // Author & Like row
                    Row(
                      children: [
                        Text(
                          article.authorName ?? 'Unknown',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: const Color.fromARGB(255, 93, 93, 93),
                              ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.thumb_up, size: 14, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '${articleDetail.likes?.length ?? 0}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 13,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isValidUrl(imageUrl)
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: const Center(
                              child:
                                  Icon(Icons.broken_image, color: Colors.white),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.white),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Build a bullet-point list for liveOpinions
  List<Widget> _buildLiveOpinionList(List<ArticleDetailEntity> opinions) {
    final List<Widget> items = [];
    for (final opinion in opinions) {
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  opinion.article.title ?? 'No Title',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return items;
  }
}
