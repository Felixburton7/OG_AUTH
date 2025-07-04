part of 'current_selections_bloc.dart';

abstract class CurrentSelectionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrentSelectionsInitial extends CurrentSelectionsState {}

class CurrentSelectionsLoading extends CurrentSelectionsState {}

class CurrentSelectionsLoaded extends CurrentSelectionsState {
  final LeagueDetails leagueDetails;
  final List<FixtureEntity> currentFixtures;
  final List<String> availableTeamNames;
  final List<String> unavailableTeamNames;
  final String? selectedTeamName;
  final String? errorMessage;
  final String? successMessage;
  final bool survivorStatus;
  final bool hasSelectionChanged;
  final int? activeGameWeek; // New field for active game week

  CurrentSelectionsLoaded({
    required this.leagueDetails,
    required this.currentFixtures,
    required this.availableTeamNames,
    required this.unavailableTeamNames,
    required this.survivorStatus,
    this.selectedTeamName,
    this.errorMessage,
    this.successMessage,
    this.hasSelectionChanged = false,
    this.activeGameWeek, // Initialize with null or actual value
  });

  CurrentSelectionsLoaded copyWith({
    LeagueDetails? leagueDetails,
    List<FixtureEntity>? currentFixtures,
    List<String>? availableTeamNames,
    List<String>? unavailableTeamNames,
    String? selectedTeamName,
    String? errorMessage,
    String? successMessage,
    bool? survivorStatus,
    bool? hasSelectionChanged,
    int? activeGameWeek, // Include in copyWith
  }) {
    return CurrentSelectionsLoaded(
      leagueDetails: leagueDetails ?? this.leagueDetails,
      currentFixtures: currentFixtures ?? this.currentFixtures,
      availableTeamNames: availableTeamNames ?? this.availableTeamNames,
      unavailableTeamNames: unavailableTeamNames ?? this.unavailableTeamNames,
      selectedTeamName: selectedTeamName ?? this.selectedTeamName,
      errorMessage: errorMessage,
      successMessage: successMessage,
      survivorStatus: survivorStatus ?? this.survivorStatus,
      hasSelectionChanged: hasSelectionChanged ?? this.hasSelectionChanged,
      activeGameWeek: activeGameWeek ?? this.activeGameWeek, // Pass new field
    );
  }

  @override
  List<Object?> get props => [
        leagueDetails,
        currentFixtures,
        availableTeamNames,
        unavailableTeamNames,
        selectedTeamName,
        survivorStatus,
        hasSelectionChanged,
        errorMessage,
        successMessage,
        activeGameWeek, // Include in props
      ];
}

class CurrentSelectionsError extends CurrentSelectionsState {
  final String message;
  CurrentSelectionsError(this.message);

  @override
  List<Object?> get props => [message];
}
