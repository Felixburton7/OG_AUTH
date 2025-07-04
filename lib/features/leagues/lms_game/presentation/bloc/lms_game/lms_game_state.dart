// lms_game_state.dart

part of 'lms_game_bloc.dart';

abstract class LmsGameState extends Equatable {
  const LmsGameState();

  @override
  List<Object?> get props => [];
}

class LmsGameLoading extends LmsGameState {}

class LmsGameLoaded extends LmsGameState {
  final LmsGameDetails lmsGameDetails;

  const LmsGameLoaded({required this.lmsGameDetails});

  @override
  List<Object?> get props => [lmsGameDetails];
}

class LmsGameError extends LmsGameState {
  final String message;

  const LmsGameError(this.message);

  @override
  List<Object?> get props => [message];
}

class LeaveLmsGameLoading extends LmsGameState {}

class LeaveLmsGameSuccess extends LmsGameState {}

class LeaveLmsGameFailure extends LmsGameState {
  final String message;

  const LeaveLmsGameFailure(this.message);

  @override
  List<Object?> get props => [message];
}
