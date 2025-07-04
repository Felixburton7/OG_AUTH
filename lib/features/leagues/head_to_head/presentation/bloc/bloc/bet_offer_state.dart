import 'package:equatable/equatable.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/bet_offer_entity.dart';

abstract class BetOfferState extends Equatable {
  const BetOfferState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BetOfferInitial extends BetOfferState {}

/// State during bet offer creation
class BetOfferCreating extends BetOfferState {}

/// State when bet offer creation is successful
class BetOfferCreationSuccess extends BetOfferState {
  final BetOfferEntity betOffer;
  final String message;

  const BetOfferCreationSuccess({
    required this.betOffer,
    this.message = 'Bet placed successfully!',
  });

  @override
  List<Object?> get props => [betOffer, message];
}

/// State when bet offer creation fails
class BetOfferCreationFailure extends BetOfferState {
  final String error;

  const BetOfferCreationFailure({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
