part of 'join_league_cubit.dart';

@immutable
class JoinLeagueState extends Equatable {
  final int? createLeagueStep;
  final String leagueTitle;
  final bool? leagueIsPrivate;
  final String?
      firstSurvivorRoundStartDate; // Updated to store the gameweek_id as a String
  final String? leagueAvatarUrl;
  final int? maxPlayers;
  final File? image;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final LeagueDTO? createdLeague;
  final List<Map<String, String>>?
      upcomingGameWeeks; // Added to store fetched game weeks

  const JoinLeagueState({
    this.createLeagueStep = 1,
    this.leagueTitle = '',
    this.leagueIsPrivate,
    this.firstSurvivorRoundStartDate,
    this.leagueAvatarUrl,
    this.image,
    this.maxPlayers,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.createdLeague,
    this.upcomingGameWeeks, // Initialize the list of upcoming game weeks
  });

  JoinLeagueState copyWith({
    int? createLeagueStep,
    String? leagueTitle,
    double? buyIn,
    bool? leagueIsPrivate,
    String?
        firstSurvivorRoundStartDate, // Note: It's now a String to store gameweek_id
    String? leagueAvatarUrl,
    File? image,
    int? maxPlayers,
    FormzSubmissionStatus? status,
    String? errorMessage,
    LeagueDTO? createdLeague,
    List<Map<String, String>>?
        upcomingGameWeeks, // Added to the copyWith method
  }) {
    return JoinLeagueState(
      createLeagueStep: createLeagueStep ?? this.createLeagueStep,
      leagueTitle: leagueTitle ?? this.leagueTitle,
      leagueIsPrivate: leagueIsPrivate ?? this.leagueIsPrivate,
      firstSurvivorRoundStartDate:
          firstSurvivorRoundStartDate ?? this.firstSurvivorRoundStartDate,
      leagueAvatarUrl: leagueAvatarUrl ?? this.leagueAvatarUrl,
      image: image ?? this.image,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdLeague: createdLeague ?? this.createdLeague,
      upcomingGameWeeks: upcomingGameWeeks ??
          this.upcomingGameWeeks, // Copy the upcoming game weeks
    );
  }

  @override
  List<Object?> get props => [
        createLeagueStep,
        leagueTitle,
        leagueIsPrivate,
        firstSurvivorRoundStartDate,
        leagueAvatarUrl,
        image,
        status,
        maxPlayers,
        errorMessage,
        createdLeague,
        upcomingGameWeeks, // Added to the props list
      ];
}

class JoinLeagueInitial extends JoinLeagueState {}

class VerifyAddCode extends JoinLeagueState {}

class JoinLeagueLoading extends JoinLeagueState {}

class JoinLeagueLoaded extends JoinLeagueState {
  final LeagueSummary league;

  const JoinLeagueLoaded({required this.league});

  @override
  List<Object?> get props => [league];
}

class JoinLeagueError extends JoinLeagueState {
  final String message;

  const JoinLeagueError(this.message);

  @override
  List<Object> get props => [message];
}

class JoinLeagueSuccess extends JoinLeagueState {}
