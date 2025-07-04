import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/usecases/fetch_all_leagues_usecase.dart';
import 'package:panna_app/features/leagues/league_home/domain/usecases/fetch_league_members_use_case.dart';
import 'package:panna_app/features/leagues/league_home/domain/usecases/fetch_league_survivor_rounds_usecase.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/verify_add_code_usecase.dart';
import 'package:supabase/supabase.dart';
// Import for Either

part 'join_league_state.dart';

@injectable
class JoinLeagueCubit extends Cubit<JoinLeagueState> {
  final FetchUserLeaguesUseCase fetchUserLeaguesUseCase;
  final FetchLeagueMembersUseCase fetchLeagueMembersUseCase;
  final FetchLeagueSurvivorRoundsUseCase fetchLeagueSurvivorRoundsUseCase;
  final VerifyAddCodeUsecase verifyAddCodeUsecase;
  final ManageLeaguesRepository manageLeaguesRepository;

  JoinLeagueCubit({
    required this.fetchUserLeaguesUseCase,
    required this.fetchLeagueMembersUseCase,
    required this.fetchLeagueSurvivorRoundsUseCase,
    required this.verifyAddCodeUsecase,
    required this.manageLeaguesRepository,
  }) : super(JoinLeagueInitial());

  Future<void> verifyAddCode(String addCode) async {
    try {
      emit(JoinLeagueLoading());

      // Get Either result from use case
      final leagueResult = await verifyAddCodeUsecase.execute(addCode);

      leagueResult.fold(
        (failure) {
          String errorMessage;
          errorMessage = 'Server error occurred';
          emit(JoinLeagueError(errorMessage));
        },
        (league) {
          emit(JoinLeagueLoaded(league: league));
        },
      );
    } on PostgrestException catch (e) {
      emit(JoinLeagueError(e.message));
    } catch (e) {
      emit(JoinLeagueError('An unexpected error occurred'));
    }
  }

  // Method to join the league
  Future<void> joinLeague(BuildContext context, String leagueId) async {
    try {
      emit(JoinLeagueLoading());

      await manageLeaguesRepository.joinLeague(leagueId);

      emit(JoinLeagueSuccess()); // Emit success state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully joined the league!')),
      );
    } catch (e) {
      emit(JoinLeagueError('Failed to join the league.'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join the league: $e')),
      );
    }
  }
}
