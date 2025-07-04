import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/articles/presentation/bloc/articles/articles_bloc.dart';

class UnlikeButton extends StatelessWidget {
  final String articleId;

  const UnlikeButton({
    Key? key,
    required this.articleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.thumb_down),
      label: const Text('Unlike'),
      onPressed: () {
        // Dispatch the UnlikeArticleEvent.
        BlocProvider.of<ArticlesBloc>(context)
            .add(UnlikeArticleEvent(articleId: articleId));
      },
    );
  }
}
