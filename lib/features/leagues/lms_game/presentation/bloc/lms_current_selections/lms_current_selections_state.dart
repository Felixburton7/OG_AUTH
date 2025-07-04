// lms_current_selections_state.dart

part of 'lms_current_selections_bloc.dart';

sealed class LmsCurrentSelectionsState extends Equatable {
  const LmsCurrentSelectionsState();

  @override
  List<Object> get props => [];
}

final class LmsCurrentSelectionsInitial extends LmsCurrentSelectionsState {}

class LmsCurrentSelectionsLoading extends LmsCurrentSelectionsState {}

class LmsCurrentSelectionsLoaded extends LmsCurrentSelectionsState {
  final LmsGameDetails lmsGameDetails;
  final List<FixtureEntity> currentFixtures;
  final List<String> availableTeamNames;
  final List<String> unavailableTeamNames;
  final String? selectedTeamName;
  final String? errorMessage;
  final String? successMessage;
  final bool survivorStatus;
  final bool hasSelectionChanged;
  final int? activeGameWeek;

  LmsCurrentSelectionsLoaded({
    required this.lmsGameDetails,
    required this.currentFixtures,
    required this.availableTeamNames,
    required this.unavailableTeamNames,
    required this.survivorStatus,
    this.selectedTeamName,
    this.errorMessage,
    this.successMessage,
    this.hasSelectionChanged = false,
    this.activeGameWeek,
  });

  LmsCurrentSelectionsLoaded copyWith({
    LmsGameDetails? lmsGameDetails,
    List<FixtureEntity>? currentFixtures,
    List<String>? availableTeamNames,
    List<String>? unavailableTeamNames,
    String? selectedTeamName,
    String? errorMessage,
    String? successMessage,
    bool? survivorStatus,
    bool? hasSelectionChanged,
    int? activeGameWeek,
  }) {
    return LmsCurrentSelectionsLoaded(
      lmsGameDetails: lmsGameDetails ?? this.lmsGameDetails,
      currentFixtures: currentFixtures ?? this.currentFixtures,
      availableTeamNames: availableTeamNames ?? this.availableTeamNames,
      unavailableTeamNames: unavailableTeamNames ?? this.unavailableTeamNames,
      selectedTeamName: selectedTeamName ?? this.selectedTeamName,
      errorMessage: errorMessage,
      successMessage: successMessage,
      survivorStatus: survivorStatus ?? this.survivorStatus,
      hasSelectionChanged: hasSelectionChanged ?? this.hasSelectionChanged,
      activeGameWeek: activeGameWeek ?? this.activeGameWeek,
    );
  }

  @override
  List<Object> get props => [
        lmsGameDetails,
        currentFixtures,
        availableTeamNames,
        unavailableTeamNames,
        selectedTeamName ?? '',
        survivorStatus,
        hasSelectionChanged,
        errorMessage ?? '',
        successMessage ?? '',
        activeGameWeek ?? 0,
      ];
}

class LmsCurrentSelectionsError extends LmsCurrentSelectionsState {
  final String message;
  LmsCurrentSelectionsError(this.message);

  @override
  List<Object> get props => [message];
}
