// // pay_buy_in_bloc.dart

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:injectable/injectable.dart';
// import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

// part 'pay_buy_in_event.dart';
// part 'pay_buy_in_state.dart';

// @injectable
// class PayBuyInBloc extends Bloc<PayBuyInEvent, PayBuyInState> {
//   final ManageLeaguesRepository manageLeaguesRepository;

//   PayBuyInBloc({required this.manageLeaguesRepository})
//       : super(PayBuyInInitial()) {
//     on<InitiatePayBuyIn>(_onInitiatePayBuyIn);
//   }

//   Future<void> _onInitiatePayBuyIn(
//     InitiatePayBuyIn event,
//     Emitter<PayBuyInState> emit,
//   ) async {
//     emit(PayBuyInLoading());
//     try {
//       final result = await manageLeaguesRepository.payBuyIn(event.leagueId);
//       if (result) {
//         emit(PayBuyInSuccess());
//       } else {
//         emit(const PayBuyInFailure('Payment failed. Please try again.'));
//       }
//     } on Exception catch (e) {
//       final message = e.toString().toLowerCase();
//       if (message.contains('insufficient')) {
//         emit(const PayBuyInFailure('insufficient_funds'));
//       } else {
//         emit(const PayBuyInFailure(
//             'An unexpected error occurred. Please try again.'));
//       }
//     }
//   }
// }
