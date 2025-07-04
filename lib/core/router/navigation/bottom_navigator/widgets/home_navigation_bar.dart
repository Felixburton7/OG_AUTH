// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // import '../cubit/bottom_navigation_bar_cubit.dart';

// // class HomeNavigationBar extends StatelessWidget {
// //   const HomeNavigationBar({
// //     super.key,
// //     required this.selectedIndex,
// //     required this.tabs,
// //   });

// //   final int selectedIndex;
// //   final List<TabItem> tabs;

// //   @override
// //   Widget build(BuildContext context) {
// //     return NavigationBar(
// //       selectedIndex: selectedIndex,
// //       onDestinationSelected: (index) =>
// //           context.read<BottomNavigationBarCubit>().switchTab(index, context),
// //       destinations: tabs
// //           .map((tab) => NavigationDestination(
// //                 label: tab.label,
// //                 icon: Icon(tab.icon),
// //               ))
// //           .toList(),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:panna_app/core/constants/colors.dart';
// import '../cubit/bottom_navigation_bar_cubit.dart';

// class HomeNavigationBar extends StatelessWidget {
//   const HomeNavigationBar({
//     super.key,
//     required this.selectedIndex,
//     required this.tabs,
//   });

//   final int selectedIndex;
//   final List<TabItem> tabs;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;

//     return Padding(
//       padding: EdgeInsets.zero,
//       child: NavigationBarTheme(
//         data: NavigationBarThemeData(
//           // Remove any background indicator for the selected tab.
//           indicatorColor: Colors.transparent,
//           labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
//             (states) {
//               final bool isSelected = states.contains(MaterialState.selected);
//               // For dark mode: unselected text is white, selected text is AppColors.secondaryColorL.
//               // For light mode: unselected text uses theme.colorScheme.secondary, selected text is AppColors.selectGreen.
//               if (isSelected) {
//                 return theme.textTheme.bodyMedium!.copyWith(
//                   color: isDarkMode
//                       ? theme.colorScheme.secondary
//                       : AppColors.selectGreen,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 );
//               }
//               return theme.textTheme.bodyMedium!.copyWith(
//                 color: isDarkMode ? Colors.white : theme.colorScheme.secondary,
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//               );
//             },
//           ),
//           iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
//             (states) {
//               final bool isSelected = states.contains(MaterialState.selected);
//               // For dark mode: unselected icon is white, selected icon is AppColors.secondaryColorL.
//               // For light mode: unselected icon uses theme.colorScheme.secondary, selected icon is AppColors.selectGreen.
//               if (isSelected) {
//                 return IconThemeData(
//                   color: isDarkMode
//                       ? theme.colorScheme.secondary
//                       : AppColors.selectGreen,
//                   size: 25,
//                 );
//               }
//               return IconThemeData(
//                 color: isDarkMode ? Colors.white : theme.colorScheme.secondary,
//                 size: 25,
//               );
//             },
//           ),
//         ),
//         child: NavigationBar(
//           selectedIndex: selectedIndex,
//           onDestinationSelected: (index) => context
//               .read<BottomNavigationBarCubit>()
//               .switchTab(index, context),
//           destinations: tabs
//               .map(
//                 (tab) => NavigationDestination(
//                   label: tab.label,
//                   icon: Icon(tab.icon),
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/colors.dart';
import '../cubit/bottom_navigation_bar_cubit.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.tabs,
  });

  final int selectedIndex;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.zero,
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          // Remove any background indicator for the selected tab.
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (states) {
              final bool isSelected = states.contains(MaterialState.selected);
              if (isSelected) {
                return theme.textTheme.bodyMedium!.copyWith(
                  color: isDarkMode
                      ? theme.colorScheme.secondary
                      : AppColors.selectGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                );
              }
              return theme.textTheme.bodyMedium!.copyWith(
                color: isDarkMode ? Colors.white : theme.colorScheme.secondary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              );
            },
          ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
            (states) {
              final bool isSelected = states.contains(MaterialState.selected);
              if (isSelected) {
                return IconThemeData(
                  color: isDarkMode
                      ? theme.colorScheme.secondary
                      : AppColors.selectGreen,
                  size: 25,
                );
              }
              return IconThemeData(
                color: isDarkMode ? Colors.white : theme.colorScheme.secondary,
                size: 25,
              );
            },
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => context
              .read<BottomNavigationBarCubit>()
              .switchTab(index, context),
          destinations: tabs
              .map(
                (tab) => NavigationDestination(
                  label: tab.label,
                  icon: Icon(tab.icon),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
