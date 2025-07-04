part of 'h2h_bloc.dart';

abstract class H2hState extends Equatable {
  const H2hState();
  @override
  List<Object?> get props => [];
}

class H2hLoading extends H2hState {}

class H2hLoaded extends H2hState {
  final H2hGameDetails h2hGameDetails;

  const H2hLoaded({required this.h2hGameDetails});

  @override
  List<Object?> get props => [h2hGameDetails];
}

class H2hError extends H2hState {
  final String message;

  const H2hError(this.message);

  @override
  List<Object?> get props => [message];
}
