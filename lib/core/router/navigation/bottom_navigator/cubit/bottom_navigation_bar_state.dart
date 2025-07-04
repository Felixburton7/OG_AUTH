part of 'bottom_navigation_bar_cubit.dart';

// States associated with the Navigation Bar

@immutable
class BottomNavigationBarState extends Equatable {
  BottomNavigationBarState({
    this.selectedIndex = 0,
  });

  final int selectedIndex;
  final tabs = <TabItem>[
    TabItem(
      label: 'Leagues',
      icon: FontAwesomeIcons.shield,
      tooltip: 'Leagues',
      content: AllLeaguesHomepage(),
    ),
    // const TabItem(
    //   label: "Home",
    //   icon: Icons.home_rounded,
    //   tooltip: "Home",
    //   content: ArticlesHome(),
    // ),
    const TabItem(
      label: 'Live',
      icon: Icons.bar_chart,
      tooltip: 'Live',
      content: LiveScoresStandingsPage(),
    ),
    const TabItem(
      label: 'Chats',
      icon: Icons.chat_bubble,
      tooltip: 'Chats',
      content: ChatLandingPage(),
    ),
    const TabItem(
        label: "Profile",
        icon: Icons.account_circle,
        tooltip: "Profile",
        content: AccountPage()
        // content: MyProfilePage(),
        ),
  ];

  BottomNavigationBarState copyWith({int? selectedIndex}) {
    return BottomNavigationBarState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [
        selectedIndex,
        tabs,
      ];
}

// TabItem Blueprint Class
class TabItem {
  const TabItem({
    required this.tooltip,
    required this.label,
    required this.icon,
    required this.content,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final Widget content;
}
