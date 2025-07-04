import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/app/app_theme.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the logo path based on the current theme
    final String logoPath = Theme.of(context).brightness == Brightness.light
        ? AppThemeAssets.lightLogo
        : AppThemeAssets.darkLogo;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.55,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 80, // Adjust the height as needed
            padding: const EdgeInsets.all(8.0),
            child: DrawerHeader(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Aligns the image to the left
                  children: [
                    Transform.scale(
                      scale: 0.9, // 30% smaller
                      child: Image.asset(
                        logoPath, // Dynamic logo path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text(
              'Create League',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.push(Routes.CreateLeague.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text(
              'Join League',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.push(Routes.joinLeague.path);
            },
          ),
          Divider(
            thickness: 0.5, // Optional, adjust thickness if needed
            indent: MediaQuery.of(context).size.width *
                0.02, // 10% indent from the left
            endIndent: MediaQuery.of(context).size.width *
                0.02, // 10% indent from the right
          ),

          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //   child: Text(
          //     'Pinned Leagues',
          //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //           fontWeight: FontWeight.bold,
          //         ),
          //   ),
          // ),
          // ListTile(
          //   leading: const CircleAvatar(
          //     backgroundImage: AssetImage('assets/images/aston_villa.png'),
          //   ),
          //   title: const Text('Example1'),
          //   onTap: () {
          //     // Handle league 1 action
          //   },
          // ),
          // ListTile(
          //   leading: const CircleAvatar(
          //     backgroundImage: AssetImage('assets/images/wolves.png'),
          //   ),
          //   title: const Text('Example 2'),
          //   onTap: () {
          //     // Handle league 2 action
          //   },
          // ),
          // ListTile(
          //   leading: const CircleAvatar(
          //     backgroundImage: AssetImage('assets/images/chelsea.png'),
          //   ),
          //   title: const Text('Example 3'),
          //   onTap: () {
          //     // Handle league 2 action
          //   },
          // ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.push(Routes.home.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text(
              'Feedback',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.push(Routes.feedback.path);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text(
              'Help',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              context.push(Routes.help.path);
            },
          ),
        ],
      ),
    );
  }
}
