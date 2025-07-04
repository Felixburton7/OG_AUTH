import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/create_bet_offer.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_state.dart';

@injectable
class BetOfferBloc extends Bloc<BetOfferEvent, BetOfferState> {
  final CreateBetOfferUseCase createBetOfferUseCase;

  BetOfferBloc({
    required this.createBetOfferUseCase,
  }) : super(BetOfferInitial()) {
    on<CreateBetOfferEvent>(_onCreateBetOffer);
    on<ResetBetOfferStateEvent>(_onResetState);
  }

  Future<void> _onCreateBetOffer(
    CreateBetOfferEvent event,
    Emitter<BetOfferState> emit,
  ) async {
    emit(BetOfferCreating());

    try {
      print('Attempting to create bet offer:');
      print('  Fixture: ${event.fixtureId}');
      print('  Team: ${event.teamId}');
      print('  Gameweek: ${event.gameweekId}');
      print('  Stake: ${event.stakeAmount}');
      print('  Odds: ${event.odds}');

      final params = CreateBetOfferParams(
        fixtureId: event.fixtureId,
        teamId: event.teamId,
        gameweekId: event.gameweekId,
        leagueId: event.leagueId,
        odds: event.odds,
        stakeAmount: event.stakeAmount,
        deadline: event.deadline,
      );

      final result = await createBetOfferUseCase.execute(params);

      result.fold(
        (failure) {
          print('Failed to create bet offer: ${failure.message}');
          emit(BetOfferCreationFailure(error: failure.message));
        },
        (betOffer) {
          print('Successfully created bet offer: ${betOffer.betId}');
          emit(BetOfferCreationSuccess(betOffer: betOffer));
        },
      );
    } catch (e) {
      print('Exception creating bet offer: $e');
      emit(BetOfferCreationFailure(error: 'An unexpected error occurred: $e'));
    }
  }

  void _onResetState(
    ResetBetOfferStateEvent event,
    Emitter<BetOfferState> emit,
  ) {
    emit(BetOfferInitial());
  }
}
