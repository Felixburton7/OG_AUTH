import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);

//   @override
//   _SplashPageState createState() => _SplashPageState();
// }

// /// Define this outside the SplashPage class
// class _AuthBlocListener extends StatefulWidget {
//   final Widget child;
//   final VoidCallback onNavigate;

//   const _AuthBlocListener(
//       {Key? key, required this.child, required this.onNavigate})
//       : super(key: key);

//   @override
//   __AuthBlocListenerState createState() => __AuthBlocListenerState();
// }

// class __AuthBlocListenerState extends State<_AuthBlocListener> {
//   bool _isNavigating = false;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthBlocState>(
//       listener: (context, state) {
//         if (state is AuthUserAuthenticated && !_isNavigating) {
//           _isNavigating = true;
//           widget.onNavigate();
//         }
//       },
//       child: widget.child,
//     );
//   }
// }

// class _SplashPageState extends State<SplashPage> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;
//   Timer? _storyTimer;

//   final List<Map<String, dynamic>> stories = [
//     {
//       "icon": Icons.people,
//       "title": "Are you ready to join our Football Community?",
//       "description":
//           "Welcome to Panna, the only app you need for everything football. Stay on top of live scores, breaking news, and connect with fans.",
//       "gradient": LinearGradient(
//         colors: [
//           Colors.blue.shade900, // Darker Blue
//           Colors.blue.shade700,
//           Colors.blue.shade400, // Lighter Blue
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     },
//     {
//       "icon": Icons.monetization_on,
//       "title": "We hope you're Feeling Competitive",
//       "description":
//           "Play, predict, and challenge your mates or rivals for real cash or bragging rights.",
//       "gradient": LinearGradient(
//         colors: [
//           const Color.fromARGB(255, 12, 73, 15), // Darker Green
//           Colors.green.shade600,
//           Colors.green.shade100, // Lighter Green
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     },
//     {
//       "icon": Icons.link,
//       "title": "Invite friends and compete for prizes",
//       "description":
//           "Invite others through private leagues or join bigger public leagues",
//       "gradient": LinearGradient(
//         colors: [
//           Colors.purple.shade900, // Darker Purple
//           Colors.purple.shade700,
//           Colors.purple.shade500, // Lighter Purple
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     },
//     {
//       "icon": Icons.leaderboard,
//       "title": "Our First Game... Last Man Standing",
//       "description":
//           "Sign up now and try out the beta version of our first game.",
//       "gradient": LinearGradient(
//         colors: [
//           Colors.orange.shade900, // Darker Orange
//           const Color.fromARGB(124, 165, 83, 0),
//           Colors.orange.shade900, // Lighter Orange
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startStoryTimer();
//     });
//   }

//   @override
//   void dispose() {
//     _storyTimer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _startStoryTimer() {
//     // 1) Make the autochange slower by increasing the duration from 5 to 7 seconds
//     _storyTimer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
//       if (!mounted) return; // Ensure the widget is still in the widget tree
//       if (_currentIndex < stories.length - 1) {
//         _goToNextPage();
//       } else {
//         setState(() {
//           _currentIndex = 0;
//         });
//         _pageController.jumpToPage(_currentIndex);
//       }
//     });
//   }

//   void _goToPreviousPage() {
//     if (_pageController.hasClients && _currentIndex > 0) {
//       _currentIndex--;
//       _pageController.animateToPage(
//         _currentIndex,
//         duration: const Duration(milliseconds: 700),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _goToNextPage() {
//     if (_pageController.hasClients && _currentIndex < stories.length - 1) {
//       _currentIndex++;
//       _pageController.animateToPage(
//         _currentIndex,
//         // Optionally, you can make the transition animation slower
//         duration: const Duration(milliseconds: 500), // Increased duration
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _navigateToHome() {
//     context.push('/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _AuthBlocListener(
//       onNavigate: () {
//         _navigateToHome();
//       },
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: stories[_currentIndex]['gradient'], // Apply gradient here
//           ),
//           child: SafeArea(
//             child: GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTapUp: (details) {
//                 final screenWidth = MediaQuery.of(context).size.width;
//                 // Tap left -> previous, tap right -> next
//                 if (details.localPosition.dx < screenWidth / 2) {
//                   _goToPreviousPage();
//                 } else {
//                   _goToNextPage();
//                 }
//               },
//               child: Stack(
//                 children: [
//                   // PageView for the story content
//                   PageView.builder(
//                     controller: _pageController,
//                     itemCount: stories.length,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentIndex = index;
//                       });
//                     },
//                     itemBuilder: (context, index) {
//                       return _buildStoryPage(stories[index]);
//                     },
//                   ),
//                   // Progress indicators at the top (like Instagram)
//                   Positioned(
//                     top: 16,
//                     left: 16,
//                     right: 16,
//                     child: Row(
//                       children: List.generate(stories.length, (index) {
//                         return Expanded(
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                             height: 4,
//                             decoration: BoxDecoration(
//                               color: index <= _currentIndex
//                                   ? const Color.fromARGB(255, 25, 90, 194)
//                                   : Colors.grey.shade700,
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                   // "Get Started" button near bottom center
//                   Positioned(
//                     bottom: 40,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           context.push('/loginOrsignup');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               const Color.fromARGB(255, 25, 90, 194),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                           ),
//                           minimumSize: const Size(150, 48),
//                         ),
//                         child: const Text('Get Started',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStoryPage(Map<String, dynamic> story) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity, // Ensure full height
//       padding: const EdgeInsets.symmetric(
//           horizontal: 24.0,
//           vertical: 60.0), // 3) Increased vertical padding from 50 to 60
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
//         children: [
//           /// --- TOP TEXT (TITLE + DESCRIPTION) ---
//           Text(
//             story['title'] ?? '',
//             style: const TextStyle(
//               fontSize: 27, // Adjusted font size
//               color: Colors.white, // Changed to white for better contrast
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12), // Reduced spacing
//           Text(
//             story['description'] ?? '',
//             style: const TextStyle(
//               fontSize: 16,
//               color:
//                   Colors.white70, // Changed to white70 for better readability
//             ),
//           ),

//           /// --- SPACE FOR CENTERING ICON ---
//           Expanded(
//             child: Center(
//               child: Icon(
//                 story['icon'],
//                 size: 150, // 2) Increased icon size from 120 to 150
//                 color: Colors.white, // Changed to white for better visibility
//               ),
//             ),
//           ),

//           /// --- BOTTOM SPACER ---
//           // Removed fixed SizedBox to prevent gaps
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

/// Define this outside the SplashPage class
class _AuthBlocListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onNavigate;

  const _AuthBlocListener(
      {Key? key, required this.child, required this.onNavigate})
      : super(key: key);

  @override
  __AuthBlocListenerState createState() => __AuthBlocListenerState();
}

class __AuthBlocListenerState extends State<_AuthBlocListener> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthUserAuthenticated && !_isNavigating) {
          _isNavigating = true;
          widget.onNavigate();
        }
      },
      child: widget.child,
    );
  }
}

class _SplashPageState extends State<SplashPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _storyTimer;

  final List<Map<String, dynamic>> stories = [
    {
      "icon": Icons.people,
      "title": "Are you ready to join our Football Community?",
      "description":
          "Welcome to Panna, the only app you need for everything football. Stay on top of live scores, breaking news, and connect with friends.",
      "gradient": LinearGradient(
        colors: [
          Colors.blue.shade900, // Darker Blue
          Colors.blue.shade700,
          Colors.blue.shade400, // Lighter Blue
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      "icon": Icons.monetization_on,
      "title": "We hope you're Feeling Competitive",
      "description":
          "Play, predict, and challenge your mates or rivals for real cash or bragging rights.",
      "gradient": LinearGradient(
        colors: [
          Colors.green.shade800, // Darker Green
          Colors.green.shade600,
          Colors.green.shade100, // Lighter Green
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      "icon": Icons.link,
      "title": "Invite friends and compete for prizes",
      "description":
          "Invite others through private leagues or join bigger public leagues",
      "gradient": LinearGradient(
        colors: [
          Colors.purple.shade900, // Darker Purple
          Colors.purple.shade700,
          Colors.purple.shade500, // Lighter Purple
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      "icon": Icons.leaderboard,
      "title": "Our First Game... Last Man Standing",
      "description":
          "Sign up now and try out the beta version of the first community game.",
      "gradient": LinearGradient(
        colors: [
          Colors.orange.shade900, // Darker Orange
          const Color.fromARGB(124, 165, 83, 0),
          Colors.orange.shade900, // Lighter Orange
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startStoryTimer();
    });
  }

  @override
  void dispose() {
    _storyTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    // 1) Make the autochange slower by increasing the duration from 5 to 7 seconds
    _storyTimer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (!mounted) return; // Ensure the widget is still in the widget tree
      if (_currentIndex < stories.length - 1) {
        _goToNextPage();
      } else {
        setState(() {
          _currentIndex = 0;
        });
        _pageController.jumpToPage(_currentIndex);
      }
    });
  }

  void _goToPreviousPage() {
    if (_pageController.hasClients && _currentIndex > 0) {
      _currentIndex--;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500), // Increased duration
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update the UI
    }
  }

  void _goToNextPage() {
    if (_pageController.hasClients && _currentIndex < stories.length - 1) {
      _currentIndex++;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500), // Increased duration
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update the UI
    }
  }

  void _navigateToHome() {
    context.push('/home');
  }

  @override
  Widget build(BuildContext context) {
    // Extract the top color from the current story's gradient
    Color buttonColor;
    try {
      final currentGradient =
          stories[_currentIndex]['gradient'] as LinearGradient;
      buttonColor = currentGradient.colors[0];
    } catch (e) {
      // Fallback color in case of error
      buttonColor = const Color.fromARGB(255, 25, 90, 194);
      debugPrint('Error extracting button color: $e');
    }

    return _AuthBlocListener(
      onNavigate: () {
        _navigateToHome();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: stories[_currentIndex]['gradient'], // Apply gradient here
          ),
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                // Tap left -> previous, tap right -> next
                if (details.localPosition.dx < screenWidth / 2) {
                  _goToPreviousPage();
                } else {
                  _goToNextPage();
                }
              },
              child: Stack(
                children: [
                  // PageView for the story content
                  PageView.builder(
                    controller: _pageController,
                    itemCount: stories.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildStoryPage(stories[index]);
                    },
                  ),
                  // Progress indicators at the top (fixed color)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: List.generate(stories.length, (index) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            height: 4,
                            decoration: BoxDecoration(
                              color: index <= _currentIndex
                                  ? Colors.black.withOpacity(
                                      0.3) // Fixed color for completed
                                  : Colors.grey
                                      .shade600, // Fixed color for remaining
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // "Get Started" button near bottom center
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/loginOrsignup');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor, // Dynamic Button Color
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: const Size(150, 48),
                        ),
                        child: const Text('Get Started',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryPage(Map<String, dynamic> story) {
    return Container(
      width: double.infinity,
      height: double.infinity, // Ensure full height
      padding: const EdgeInsets.symmetric(
          horizontal: 24.0, vertical: 60.0), // Further down
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          /// --- TOP TEXT (TITLE + DESCRIPTION) ---
          Text(
            story['title'] ?? '',
            style: const TextStyle(
              fontSize: 27, // Adjusted font size
              color: Colors.white, // Changed to white for better contrast
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12), // Reduced spacing
          Text(
            story['description'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              color:
                  Colors.white70, // Changed to white70 for better readability
            ),
          ),

          /// --- SPACE FOR CENTERING ICON ---
          Expanded(
            child: Center(
              child: Icon(
                story['icon'],
                size: 150, // Increased icon size from 120 to 150
                color: Colors.white, // Changed to white for better visibility
              ),
            ),
          ),

          /// --- BOTTOM SPACER ---
          // Removed fixed SizedBox to prevent gaps
        ],
      ),
    );
  }
}
