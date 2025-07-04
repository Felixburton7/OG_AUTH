import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';
import 'package:panna_app/features/articles/presentation/bloc/articles/articles_bloc.dart';
import 'package:share_plus/share_plus.dart'; // <-- For sharing
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // <-- Add this import

// Example placeholder enums/functions for toggling font sizes
enum FontSizeOption { small, medium, large }

class ArticleDetailsPage extends StatefulWidget {
  final ArticleDetailEntity articleDetail;

  const ArticleDetailsPage({
    Key? key,
    required this.articleDetail,
  }) : super(key: key);

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final String? currentUserId = Supabase.instance.client.auth.currentUser?.id;

  FontSizeOption currentFontSize = FontSizeOption.medium;

  /// Converts a date to "Today", "Yesterday", or "<n> days ago"
  /// If `date` is null, returns an empty string.
  String _relativeTime(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 2) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return 'Today';
    }
  }

  /// Placeholder function for a floating like animation
  void showFloatingLikeAnimation() {
    debugPrint('Floating like animation triggered!');
  }

  /// Called when the like/unlike icon is pressed
  void _onLikePressed(BuildContext context, ArticlesBloc bloc, bool hasLiked) {
    // Optional: show a floating animation
    showFloatingLikeAnimation();

    if (hasLiked) {
      // User has liked => unlike
      bloc.add(UnlikeArticleEvent(articleId: widget.articleDetail.article.id));
    } else {
      // User hasn't liked => like
      bloc.add(LikeArticleEvent(articleId: widget.articleDetail.article.id));
    }
  }

  /// Toggles the font size among small, medium, large
  void _onAAIconPressed() {
    setState(() {
      switch (currentFontSize) {
        case FontSizeOption.small:
          currentFontSize = FontSizeOption.medium;
          break;
        case FontSizeOption.medium:
          currentFontSize = FontSizeOption.large;
          break;
        case FontSizeOption.large:
          currentFontSize = FontSizeOption.small;
          break;
      }
    });
  }

  /// Shares the article using `share_plus`
  void _onSharePressed(String? title, String? content) {
    final shareTitle = title ?? 'Check out this article!';
    final shareContent = content ?? 'No content available.';
    Share.share('$shareTitle\n\n$shareContent');
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.articleDetail.article;

    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        // Get updated detail from the bloc state (if loaded)
        ArticleDetailEntity currentDetail = widget.articleDetail;
        if (state is ArticlesLoaded) {
          currentDetail = state.articles.firstWhere(
            (a) => a.article.id == article.id,
            orElse: () => widget.articleDetail,
          );
        }

        // Has the current user liked it?
        final bool hasLiked = currentUserId != null &&
            currentDetail.likes.any((like) => like.profileId == currentUserId);

        // We'll also display the total like count in the app bar
        final totalLikes = currentDetail.likes.length;

        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            actions: [
              // AA toggle: small A and large A aligned on baseline
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  GestureDetector(
                    onTap: _onAAIconPressed,
                    child: const Text(
                      'A',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: _onAAIconPressed,
                    child: const Text(
                      'A',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 13),
                ],
              ),
              // Like/Unlike icon with total like count
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      hasLiked ? Icons.thumb_down_outlined : Icons.thumb_up,
                    ),
                    onPressed: () {
                      _onLikePressed(
                        context,
                        BlocProvider.of<ArticlesBloc>(context),
                        hasLiked,
                      );
                    },
                  ),
                  const SizedBox(width: 0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                    child: Text(
                      '$totalLikes',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Share icon
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                child: IconButton(
                  icon: const Icon(Icons.ios_share),
                  tooltip: 'Share',
                  onPressed: () {
                    _onSharePressed(article.title, article.content);
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  _buildArticleImage(currentDetail),
                  const SizedBox(height: 16),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      article.title ?? 'No Title',
                      style: _titleTextStyle(context),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Author's Name + Avatar + Date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(Icons.person, size: 18),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.authorName ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                _relativeTime(article.date),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color:
                                          const Color.fromARGB(255, 31, 31, 31),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Article content rendered as Markdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MarkdownBody(
                      data: article.content ?? '',
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                        // Adjust the base font sizes, headings, etc.:
                        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: _adjustBodyFontSize(),
                            ),
                        h1: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        h2: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        h3: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      onTapLink: (text, url, title) {
                        // Optionally handle link taps
                        debugPrint('Link tapped: $url');
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Divider
                  const Divider(
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  // Everyone who liked the article displayed at bottom
                  _buildLikesList(currentDetail, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the article image at the top
  Widget _buildArticleImage(ArticleDetailEntity detail) {
    final url = detail.article.imageUrl;
    if (url == null || url.isEmpty) {
      return Container(
        color: Colors.grey,
        height: 250,
        width: double.infinity,
      );
    }
    return Image.network(
      url,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (context, exception, stackTrace) {
        return Container(
          color: Colors.grey[300],
          height: 250,
          width: double.infinity,
          child: Icon(
            Icons.broken_image,
            size: 100,
            color: Colors.grey[700],
          ),
        );
      },
    );
  }

  /// Title style changes with the currentFontSize.
  TextStyle _titleTextStyle(BuildContext context) {
    double fontSize;
    switch (currentFontSize) {
      case FontSizeOption.small:
        fontSize = 20;
        break;
      case FontSizeOption.medium:
        fontSize = 24;
        break;
      case FontSizeOption.large:
        fontSize = 28;
        break;
    }
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ) ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        );
  }

  /// Adjusts body text font size based on currentFontSize
  double _adjustBodyFontSize() {
    switch (currentFontSize) {
      case FontSizeOption.small:
        return 14;
      case FontSizeOption.medium:
        return 16;
      case FontSizeOption.large:
        return 18;
    }
  }

  Widget _buildLikesList(ArticleDetailEntity detail, BuildContext context) {
    if (detail.likes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'No likes yet.',
          style: TextStyle(fontSize: 14),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Liked By:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          for (final like in detail.likes)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 15,
                backgroundColor: Theme.of(context).iconTheme.color,
                child: const Icon(
                  Icons.person,
                  size: 14,
                ),
              ),
              title: Text(
                like.username,
                style: const TextStyle(fontSize: 15),
              ),
              subtitle: like.likedAt != null
                  ? Text(
                      '${_formatLikeDate(like.likedAt!)}',
                      style: const TextStyle(fontSize: 13),
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  /// Formats a DateTime as "23 Jan 8:00PM" (day, short month, hour:minute + AM/PM).
  String _formatLikeDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day;
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = monthNames[local.month - 1];
    final hour = local.hour > 12
        ? local.hour - 12
        : local.hour == 0
            ? 12
            : local.hour;
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day $month $hour:$minute$ampm';
  }
}
