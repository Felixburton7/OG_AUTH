// import 'package:flutter/material.dart';

// class MoreNews {
//   final BuildContext context;

//   MoreNews(this.context);

//   Widget build() {
//     return Column(
//       children: [
//         _buildArticleCard(
//             context: context,
//             imageUrl:
//                 'https://cdn.images.express.co.uk/img/dynamic/67/590x/secondary/Lionel-Messi-2877297.webp?r=1648452511459',
//             title: 'Messi Eyes Another Ballon d\'Or',
//             description:
//                 'Lionel Messi is once again in the running for the prestigious Ballon d\'Or award.'),
//         _buildArticleCard(
//             context: context,
//             imageUrl:
//                 'https://www.telegraph.co.uk/content/dam/football/2023/07/25/TELEMMGLPICT000345799730_trans_NvBQzQNjv4BqpjlwNExrUbEKnZ57o6V_CjAC-nHuCcztewtEo6Pj6PM.jpeg',
//             title: 'Premier League: Title Race Heats Up',
//             description:
//                 'The Premier League title race is closer than ever with just a few points separating the top teams.'),
//       ],
//     );
//   }

//   Widget _buildArticleCard(
//       {required BuildContext context,
//       required String imageUrl,
//       required String title,
//       required String description}) {
//     return Card(
//       child: Column(
//         children: [
//           Image.network(imageUrl),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               title,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               description,
//               style: Theme.of(context).textTheme.labelLarge,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';

class ArticlesCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String articleDetails;

  const ArticlesCard(
      {super.key,
      required BuildContext context,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.articleDetails});

  @override
  Widget build(BuildContext context) {
    {
      return GestureDetector(
        onTap: () {
          // Navigate to articleDetailsPage with sample data
          context.push(
            Routes.articleDetails.path,
            extra: articleDetails,
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: imageUrl.isNotEmpty
                    ? Image.asset(
                        imageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Container(
                            color: Colors.grey,
                            height: 150,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/default_heskey_image.png',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/default_heskey_image.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }
  }
}
