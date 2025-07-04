import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/account/settings/theme_mode/presentation/bloc/theme_mode_cubit.dart';

// Extension to watch current theme
extension ThemeExtension on BuildContext {
  ThemeMode get watchCurrentThemeMode {
    return watch<ThemeModeCubit>().state.selectedThemeMode;
  }
}
