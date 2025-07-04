import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:panna_app/features/account/settings/theme_mode/domain/use_case/get_or_set_initial_theme_mode_use_case.dart';
import 'package:panna_app/features/account/settings/theme_mode/domain/use_case/set_theme_mode_id_use_case.dart';
import 'package:injectable/injectable.dart';

part 'theme_mode_state.dart';

@injectable
class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit(
    this._getOrSetInitialThemeModeUseCase,
    this._setThemeModeUseCase,
  ) : super(
          const ThemeModeState(),
        );

  final GetOrSetInitialThemeModeUseCase _getOrSetInitialThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;

  Future<void> getCurrentTheme() async {
    final systemThemeModeId = ThemeMode.system.index;

    final themeModeResult = _getOrSetInitialThemeModeUseCase.execute(
      GetOrSetInitialThemeModeUseCaseParams(
        currentThemeModeId: systemThemeModeId,
      ),
    );

    themeModeResult.fold(
      (failure) {
        // Handle failure case here if needed
      },
      (themeModeId) {
        // Emits the ThemeMode state 'values' to the current theme.
        emit(state.copyWith(
          selectedThemeMode: ThemeMode.values[themeModeId],
        ));
      },
    );
  }

  Future<void> setTheme(int? themeModeIndex) async {
    if (themeModeIndex == null) return;

    final result = await _setThemeModeUseCase.execute(
      SetThemeModeUseCaseParams(
        themeModeIndex: themeModeIndex,
      ),
    );

    result.fold(
      (failure) {
        // Handle failure case here if needed
      },
      (_) {
        emit(
          state.copyWith(
            selectedThemeMode: ThemeMode.values[themeModeIndex],
          ),
        );
      },
    );
  }
}





// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:panna_app/features/account/settings/theme_mode/domain/use_case/get_or_set_initial_theme_mode_use_case.dart';
// import 'package:panna_app/features/account/settings/theme_mode/domain/use_case/set_theme_mode_id_use_case.dart';
// import 'package:injectable/injectable.dart';
// import 'package:meta/meta.dart';

// part 'theme_mode_state.dart';

// @injectable
// class ThemeModeCubit extends Cubit<ThemeModeState> {
//   ThemeModeCubit(
//     this._getOrSetInitialThemeModeUseCase, // Takes in GetOrSet Initial ThemeMode
//     this._setThemeModeUseCase, // Takes in themeModeIndex and executes .setThemeMode
//   ) : super(
//           const ThemeModeState(),
//         );

//   final GetOrSetInitialThemeModeUseCase _getOrSetInitialThemeModeUseCase;
//   final SetThemeModeUseCase _setThemeModeUseCase;

//   void getCurrentTheme() {
//     var systemThemeModeId = ThemeMode.system.index;

//     var themeModeId = _getOrSetInitialThemeModeUseCase.execute(
//       GetOrSetInitialThemeModeUseCaseParams(
//         currentThemeModeId: systemThemeModeId,
//       ),
//     );
// // Emits the ThemeMode state 'values' to the current theme.
// // Sets the initial this.mode = ThemeMode.values
//     emit(state.copyWith(
//       selectedThemeMode: ThemeMode.values[themeModeId],
//     ));
//   }

// // Sets the ThemeMode mode to the the themModeIndex which is passed in by the frontend
// // state.mode = ThemeMode.values.
//   void setTheme(int? themeModeIndex) {
//     if (themeModeIndex == null) return;

//     _setThemeModeUseCase.execute(SetThemeModeUseCaseParams(
//       themeModeIndex: themeModeIndex,
//     ));

//     emit(
//       state.copyWith(
//         selectedThemeMode: state.modes[themeModeIndex],
//       ),
//     );
//   }
// }