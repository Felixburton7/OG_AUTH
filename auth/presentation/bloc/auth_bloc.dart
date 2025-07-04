import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/auth/data/mapper/auth_mapper.dart';
import 'package:panna_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:panna_app/features/auth/domain/use_case/get_current_auth_state_use_case.dart';
import 'package:panna_app/features/auth/domain/use_case/logout_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/use_case/get_logged_in_user_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// auth_bloc.dart

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthBlocState> {
  AuthBloc(
    this._getLoggedInUserUseCase,
    this._getAuthStateUseCase,
    this._logoutUseCase,
    this._profileCubit, // Inject ProfileCubit
  ) : super(const AuthInitial()) {
    on<AuthInitialCheckRequested>(_onInitialAuthChecked);
    on<AuthOnCurrentUserChanged>(_onCurrentUserChanged);
    on<AuthLogoutButtonPressed>(_onLogoutButtonPressed);

    _startUserSubscription();
  }

  final GetLoggedInUserUseCase _getLoggedInUserUseCase;
  final GetCurrentAuthStateUseCase _getAuthStateUseCase;
  final LogoutUseCase _logoutUseCase;
  final ProfileCubit _profileCubit;

  late final StreamSubscription<supabase_auth.AuthState>? _authSubscription;

  void _startUserSubscription() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        final event = data.event;
        final session = data.session;
        add(AuthOnCurrentUserChanged(session?.user.toUserEntity(), event));
      },
    );
  }

  Future<void> _onInitialAuthChecked(
    AuthInitialCheckRequested event,
    Emitter<AuthBlocState> emit,
  ) async {
    final result = await _getLoggedInUserUseCase.execute(NoParams());
    result.fold(
      (failure) => emit(const AuthUserUnauthenticated()),
      (signedInUser) {
        if (signedInUser != null) {
          emit(AuthUserAuthenticated(signedInUser));
        } else {
          emit(const AuthUserUnauthenticated());
        }
      },
    );
  }

  Future<void> _onCurrentUserChanged(
    AuthOnCurrentUserChanged event,
    Emitter<AuthBlocState> emit,
  ) async {
    if (event.user != null) {
      if (event.authEvent == AuthChangeEvent.passwordRecovery) {
        emit(AuthPasswordRecovery(event.user!));
      } else {
        emit(AuthUserAuthenticated(event.user!));
        // Further logic
      }
    } else {
      emit(const AuthUserUnauthenticated());
    }
  }
  // Future<void> _onCurrentUserChanged(
  //   AuthOnCurrentUserChanged event,
  //   Emitter<AuthBlocState> emit,
  // ) async {
  //   if (event.user != null) {
  //     if (event.authEvent == AuthChangeEvent.passwordRecovery) {
  //       emit(AuthPasswordRecovery(event.user!));
  //     } else {
  //       emit(AuthUserAuthenticated(event.user!));
  //       _profileCubit.clearProfile();
  //       await Future.delayed(const Duration(milliseconds: 100));
  //       _profileCubit.fetchProfile();
  //     }
  //   } else {
  //     emit(const AuthUserUnauthenticated());
  //     _profileCubit.clearProfile();
  //   }
  // }

  Future<void> _onLogoutButtonPressed(
    AuthLogoutButtonPressed event,
    Emitter<AuthBlocState> emit,
  ) async {
    final result = await _logoutUseCase.execute(NoParams());
    result.fold(
      (failure) =>
          emit(const AuthUserUnauthenticated()), // Handle failure scenario
      (_) {
        emit(const AuthUserUnauthenticated()); // Emit unauthenticated state
        _profileCubit.clearProfile(); // Clear profile state when logging out
      },
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
