import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/articles/presentation/bloc/articles/articles_bloc.dart';

class LikeButton extends StatelessWidget {
  final String articleId;

  const LikeButton({
    Key? key,
    required this.articleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.thumb_up),
      label: const Text('Like'),
      onPressed: () {
        // Dispatch the LikeArticleEvent.
        BlocProvider.of<ArticlesBloc>(context)
            .add(LikeArticleEvent(articleId: articleId));
      },
    );
  }
}
