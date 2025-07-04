import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/error/failures.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/usecases/fetch_h2h_game_details.dart';

part 'h2h_event.dart';
part 'h2h_state.dart';

@injectable
class H2hBloc extends Bloc<H2hEvent, H2hState> {
  final FetchH2hGameDetailsUseCase fetchH2hGameDetailsUseCase;

  H2hBloc({
    required this.fetchH2hGameDetailsUseCase,
  }) : super(H2hLoading()) {
    on<FetchH2hGameDetails>(_onFetchH2hGameDetails);
  }

  Future<void> _onFetchH2hGameDetails(
    FetchH2hGameDetails event,
    Emitter<H2hState> emit,
  ) async {
    emit(H2hLoading());
    try {
      print(
          'Attempting to fetch H2H game details for leagueId: ${event.leagueId}');
      final result = await fetchH2hGameDetailsUseCase.execute(event.leagueId);
      result.fold(
        (failure) => emit(H2hError('Failed to load H2H game details.')),
        (h2hGameDetails) => emit(H2hLoaded(h2hGameDetails: h2hGameDetails)),
      );
    } catch (e) {
      emit(H2hError('An unexpected error occurred: $e'));
    }
  }
}
