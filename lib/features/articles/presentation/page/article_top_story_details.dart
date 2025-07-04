// lib/pages/top_story_details_page.dart

import 'package:flutter/material.dart';

class TopStoryDetailsPage extends StatelessWidget {
  // Article Data
  final String imageUrl;
  final String author;
  final String date;
  final String title;
  final String content;

  const TopStoryDetailsPage({
    Key? key,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.title,
    required this.content,
  }) : super(key: key);

  // Helper function to parse content and create TextSpans
  List<TextSpan> _parseContent(String content, BuildContext context) {
    List<TextSpan> spans = [];
    // Split content into lines
    List<String> lines = content.split('\n');

    for (String line in lines) {
      if (line.startsWith('### ')) {
        // Header line
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
        // Regular line with potential bold text
        spans.addAll(_parseBoldText(line, context));
        spans.add(
            const TextSpan(text: '\n')); // Reduced spacing between paragraphs
      }
    }

    return spans;
  }

  // Helper function to parse bold text within a line
  List<TextSpan> _parseBoldText(String line, BuildContext context) {
    List<TextSpan> spans = [];
    int currentIndex = 0;

    while (currentIndex < line.length) {
      int boldStart = line.indexOf('**', currentIndex);
      if (boldStart == -1) {
        // No more bold markers, add the remaining text
        spans.add(TextSpan(
          text: line.substring(currentIndex),
          style: Theme.of(context).textTheme.bodyMedium,
        ));
        break;
      } else {
        // Add text before bold marker
        if (boldStart > currentIndex) {
          spans.add(TextSpan(
            text: line.substring(currentIndex, boldStart),
            style: Theme.of(context).textTheme.bodyMedium,
          ));
        }
        int boldEnd = line.indexOf('**', boldStart + 2);
        if (boldEnd == -1) {
          // No closing bold marker, treat the rest as normal text
          spans.add(TextSpan(
            text: line.substring(boldStart),
            style: Theme.of(context).textTheme.bodyMedium,
          ));
          break;
        } else {
          // Extract bold text
          String boldText = line.substring(boldStart + 2, boldEnd);
          spans.add(TextSpan(
            text: boldText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ));
          currentIndex = boldEnd + 2; // Move past the closing '**'
        }
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text(
          'Welcome Beta Testers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 16.0), // Added padding for better spacing at the bottom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Image
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

              // Author and Date Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    // Author
                    Expanded(
                      child: Text(
                        'Author: $author',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .primaryColor, // Primary color
                            ),
                      ),
                    ),
                    // Date
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

              // Article Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(title,
                    style: Theme.of(context).textTheme.displayMedium),
              ),
              const SizedBox(height: 16),

              // Article Content rendered as RichText
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RichText(
                  text: TextSpan(
                    children: _parseContent(content, context),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Ensure default style
                  ),
                ),
              ),

              // Divider
              const Divider(
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              const SizedBox(height: 16),

              // Comments Section (Placeholder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Comments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              _buildCommentsSection(context),
              const SizedBox(height: 16),

              // Share Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement share functionality here
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Comments Section (Placeholder)
  Widget _buildCommentsSection(BuildContext context) {
    // Sample comments data
    final List<Map<String, String>> comments = [
      // {
      //   'username': 'JohnDoe',
      //   'comment': 'Great introduction! Excited to use the app.',
      // },
      // {
      //   'username': 'JaneSmith',
      //   'comment': 'Looking forward to the live scores feature.',
      // },
      // {
      //   'username': 'SportsFan99',
      //   'comment': 'Can’t wait to build a community here!',
      // },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: comments.map((comment) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(comment['username']![0]),
            ),
            title: Text(
              comment['username']!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              comment['comment']!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
      ),
    );
  }
}
