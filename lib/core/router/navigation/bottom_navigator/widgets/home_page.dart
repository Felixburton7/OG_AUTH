import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/router/navigation/bottom_navigator/cubit/bottom_navigation_bar_cubit.dart';
import 'package:panna_app/core/router/navigation/bottom_navigator/widgets/home_navigation_bar.dart';
import 'package:panna_app/dependency_injection.dart';

class HomeNavigationBarPage extends StatelessWidget {
  const HomeNavigationBarPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BottomNavigationBarCubit>(),
        ),
      ],
      child: BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: state.tabs[state.selectedIndex].content,
            ),
            bottomNavigationBar: HomeNavigationBar(
              selectedIndex: state.selectedIndex,
              tabs: state.tabs,
            ),
          );
        },
      ),
    );
  }
}
