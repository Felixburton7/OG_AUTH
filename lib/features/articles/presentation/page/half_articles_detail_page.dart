import 'package:flutter/material.dart';

class HalfArticleDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String author;
  final String date;
  final String title;
  final String content;

  const HalfArticleDetailsPage({
    Key? key,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.title,
    required this.content,
  }) : super(key: key);

  List<TextSpan> _parseContent(String content, BuildContext context) {
    List<TextSpan> spans = [];
    List<String> lines = content.split('\n');

    for (String line in lines) {
      if (line.startsWith('### ')) {
        String headerText = line.substring(4); // Remove '### ' prefix
        spans.add(
          TextSpan(
            text: '$headerText\n',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        );
      } else {
        spans.addAll(_parseBoldText(line, context));
        spans.add(const TextSpan(text: '\n'));
      }
    }
    return spans;
  }

  List<TextSpan> _parseBoldText(String line, BuildContext context) {
    List<TextSpan> spans = [];
    int currentIndex = 0;

    while (currentIndex < line.length) {
      int boldStart = line.indexOf('**', currentIndex);
      if (boldStart == -1) {
        spans.add(TextSpan(
          text: line.substring(currentIndex),
          style: Theme.of(context).textTheme.bodyMedium,
        ));
        break;
      } else {
        if (boldStart > currentIndex) {
          spans.add(TextSpan(
            text: line.substring(currentIndex, boldStart),
            style: Theme.of(context).textTheme.bodyMedium,
          ));
        }
        int boldEnd = line.indexOf('**', boldStart + 2);
        if (boldEnd == -1) {
          spans.add(TextSpan(
            text: line.substring(boldStart),
            style: Theme.of(context).textTheme.bodyMedium,
          ));
          break;
        } else {
          String boldText = line.substring(boldStart + 2, boldEnd);
          spans.add(TextSpan(
            text: boldText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ));
          currentIndex = boldEnd + 2;
        }
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Feed Article',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
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
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Author: $author',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(title,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                  text: TextSpan(
                    children: _parseContent(content, context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
