import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/page/account_page.dart';
import 'package:panna_app/features/chat/presentation/pages/chat_landing_page.dart';
import 'package:panna_app/features/fixtures_and_standings/presentation/simple_fixtures_standings_page.dart';
import 'package:panna_app/features/account/profile/presentation/page/profile_page.dart';
import 'package:panna_app/features/articles/presentation/page/articles_home.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/page/all_league_homepage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
part 'bottom_navigation_bar_state.dart';

@injectable
class BottomNavigationBarCubit extends Cubit<BottomNavigationBarState> {
  BottomNavigationBarCubit()
      : super(
          BottomNavigationBarState(),
        );

  void switchTab(int index, BuildContext context) {
    // Trigger league refetch when switching to the Leagues tab
    // if (index == 2) {
    //   // Assuming the Leagues tab is at index 2
    //   BlocProvider.of<LeagueBloc>(context).add(FetchUserLeagues());
    // }
    if (index == 4) {
      BlocProvider.of<ProfileCubit>(context).fetchProfile();
//       // Retrieves an instance of the 'ProfileCubit' that was previously provided higher up in the widget tree.
//       When you call BlocProvider.of<ProfileCubit>(context) inside the switchTab method of BottomNavigationBarCubit, you're accessing the ProfileCubit instance that was provided higher up in the widget tree (in PannaApp).
// This allows BottomNavigationBarCubit to trigger methods on ProfileCubit (like fetchProfile()) when the user switches to the profile tab.
    }

    emit(state.copyWith(
      selectedIndex: index,
    ));
  }
}
