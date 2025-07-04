import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';

class CreateLeagueAfterCreationPage extends StatelessWidget {
  final LeagueDTO createdLeague;

  const CreateLeagueAfterCreationPage({Key? key, required this.createdLeague})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          createdLeague.leagueTitle ?? 'No Title',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // League Image at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(createdLeague.leagueAvatarUrl ??
                      'https://via.placeholder.com/150'), // Fallback image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Middle Container with League Details
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            height: 420,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.celebration,
                    // color: Colors.yellow,
                    size: 50,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your League has been created!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Copy and send the Game link for everyone else to join.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        createdLeague.addCode ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final addCode = createdLeague.addCode;
                        if (addCode != null) {
                          Clipboard.setData(
                            ClipboardData(text: addCode),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add Code copied to clipboard!'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy Add Code'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // "Share Add Code" Button below the container
          Positioned(
            top: 500,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final addCode = createdLeague.addCode;
                  if (addCode != null) {
                    final shareText =
                        'Join my league "${createdLeague.leagueTitle ?? 'League'}" using this Add Code: $addCode';
                    // Share.share(shareText);
                  }
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Add Code'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          // "Close" Button at the bottom
          Positioned(
            bottom: 30, // Positioned higher above the bottom
            left: 16,
            right: 16,
            child: TextButton(
              onPressed: () {
                context.push(Routes.home.path);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.transparent,
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
