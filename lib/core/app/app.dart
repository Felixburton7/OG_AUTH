import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/router/router.dart';
import 'package:panna_app/core/app/app_theme.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/articles/presentation/bloc/articles/articles_bloc.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:panna_app/features/account/settings/theme_mode/presentation/bloc/theme_mode_cubit.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart';

class PannaApp extends StatelessWidget {
  const PannaApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _AppBlocProvider(
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        buildWhen: (previous, current) =>
            previous.selectedThemeMode != current.selectedThemeMode,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Flutter and Supabase Starter',
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: darkTheme,
            themeMode: state.selectedThemeMode,
          );
        },
      ),
    );
  }
}

class _AppBlocProvider extends StatelessWidget {
  const _AppBlocProvider({
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => getIt<AuthBloc>()
              ..add(
                const AuthInitialCheckRequested(),
              )),
        BlocProvider(
          create: (_) => getIt<ThemeModeCubit>()..getCurrentTheme(),
        ),
        BlocProvider(
          create: (_) => getIt<ProfileCubit>()..fetchProfile(),
        ),
        BlocProvider(
          create: (_) => getIt<LeagueBloc>()
            ..add(
              FetchUserLeagues(), // Initialize the league fetching process
            ),
        ),
        BlocProvider(
          create: (_) => getIt<ArticlesBloc>(),
        ),
      ],
      child: child,
    );
  }
}
