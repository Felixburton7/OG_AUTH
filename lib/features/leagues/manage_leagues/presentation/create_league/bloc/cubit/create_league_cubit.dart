import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/utils/pick_image.dart';
import 'package:panna_app/core/utils/string_to_datetime.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/create_league_usecase.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/fetch_upcoming_leagues_usecase.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/usecases/update_league_usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'create_league_state.dart';

@injectable
class CreateLeagueCubit extends Cubit<CreateLeagueState> {
  final CreateLeagueUseCase _createLeagueUseCase;
  final UpdateLeagueUseCase _updateLeagueUseCase;
  final ImageUploadService _imageUploadService;
  final FetchUpcomingGameWeeksUseCase _fetchUpcomingGameWeeksUseCase;

  CreateLeagueCubit(this._createLeagueUseCase, this._updateLeagueUseCase,
      this._imageUploadService, this._fetchUpcomingGameWeeksUseCase)
      : super(CreateLeagueState());

  void moveToStep(int step) {
    emit(state.copyWith(createLeagueStep: step));
    if (step == 4) {
      fetchUpcomingGameWeeks(); // Fetch game weeks when reaching step 4
    }
  }

  void updateLeagueTitle(String value) {
    emit(state.copyWith(leagueTitle: value));
  }

  void updateBuyIn(double value) {
    emit(state.copyWith(buyIn: value));
  }

  void updateLeagueIsPrivate(bool value) {
    emit(state.copyWith(leagueIsPrivate: value));
  }

  void updateFirstSurvivorRoundStartDate(String gameweekId) {
    emit(state.copyWith(firstSurvivorRoundStartDate: gameweekId));
  }

  void updateMaxPlayers(int value) {
    emit(state.copyWith(maxPlayers: value));
  }

  void updateLeagueBio(String value) {
    emit(state.copyWith(leagueBio: value));
  }

  Future<void> selectImage() async {
    try {
      final pickedImage = await _imageUploadService.pickImage();
      if (pickedImage != null) {
        emit(state.copyWith(image: pickedImage));
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: 'Failed to select image: $error'));
    }
  }

  Future<void> submitLeague() async {
    if (state.status == FormzSubmissionStatus.inProgress) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      LeagueDTO? createdLeague = state.createdLeague;

      // Create a new league if it hasn't been created yet
      if (createdLeague == null) {
        final result = await _createLeagueUseCase.execute(
          LeagueDTO(
            leagueTitle: state.leagueTitle,
            buyIn: state.buyIn ?? 0.0,
            firstSurvivorRoundStartDate:
                state.firstSurvivorRoundStartDate, // Use the util here
            leagueIsPrivate: state.leagueIsPrivate ?? true,
            leagueBio: state.leagueBio,
            createdAt: DateTime.now(),
          ),
        );

        result.fold(
          (failure) {
            emit(state.copyWith(
                status: FormzSubmissionStatus.failure,
                errorMessage: 'Failed to create the league'));
          },
          (league) {
            createdLeague = league;
            emit(state.copyWith(createdLeague: createdLeague));
          },
        );
      }

      // If an image was selected, upload it
      if (state.image != null &&
          createdLeague != null &&
          createdLeague!.leagueAvatarUrl == null) {
        final imageUrl = await _imageUploadService.uploadImageLeague(
          state.image!,
          createdLeague!
              .leagueId!, // Non-null assertion because leagueId must be present now
        );

        // Use `copyWith` only if `createdLeague` is not null
        createdLeague = createdLeague!.copyWith(leagueAvatarUrl: imageUrl);

        // Update the league with the new avatar URL
        final updateResult = await _updateLeagueUseCase.execute(createdLeague!);

        updateResult.fold(
          (failure) => emit(state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Failed to update the league')),
          (updatedLeague) => createdLeague = updatedLeague,
        );
      }

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        createdLeague: createdLeague,
      ));
    } on PostgrestException catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Failed to create the league: ${e.message}',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'An unexpected error occurred: $e',
      ));
    }
  }

  Future<void> fetchUpcomingGameWeeks() async {
    try {
      final result = await _fetchUpcomingGameWeeksUseCase.execute(NoParams());

      result.fold(
        (failure) =>
            emit(state.copyWith(errorMessage: 'Failed to load game weeks')),
        (gameWeeks) => emit(state.copyWith(upcomingGameWeeks: gameWeeks)),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to load game weeks.'));
    }
  }
}
