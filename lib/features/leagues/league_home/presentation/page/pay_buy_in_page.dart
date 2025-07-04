import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:panna_app/core/utils/underlined_text_stack.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/features/leagues/lms_game/domain/entities/lms_game_details.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:go_router/go_router.dart';

class PayBuyInBottomSheet extends StatefulWidget {
  final LmsGameDetails lmsGameDetails;
  const PayBuyInBottomSheet({Key? key, required this.lmsGameDetails})
      : super(key: key);

  @override
  _PayBuyInBottomSheetState createState() => _PayBuyInBottomSheetState();
}

class _PayBuyInBottomSheetState extends State<PayBuyInBottomSheet> {
  bool _isLoading = false;

  Future<void> _payBuyin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final repository = getIt<ManageLeaguesRepository>();
      final success =
          await repository.payBuyIn(widget.lmsGameDetails.league.leagueId!);
      if (success) {
        // Log event for successful pay buy-in with additional user/league details.
        getIt<FirebaseAnalyticsService>()
            .logEvent('pay_buy_in_success', parameters: {
          'league_id': widget.lmsGameDetails.league.leagueId,
          'league_title': widget.lmsGameDetails.league.leagueTitle,
          'username': widget.lmsGameDetails.userProfile.username,
          'first_name': widget.lmsGameDetails.userProfile.firstName,
          'last_name': widget.lmsGameDetails.userProfile.lastName,
          'buy_in_amount': widget.lmsGameDetails.league.buyIn,
        });
        Navigator.of(context).pop(true);
      } else {
        throw Exception('Payment failed. Please try again.');
      }
    } catch (e) {
      // Log an event for insufficient funds (or other errors) when trying to pay buy-in.
      getIt<FirebaseAnalyticsService>()
          .logEvent('pay_buy_in_failure', parameters: {
        'error': e.toString(),
        'league_id': widget.lmsGameDetails.league.leagueId,
        'league_title': widget.lmsGameDetails.league.leagueTitle,
        'username': widget.lmsGameDetails.userProfile.username,
        'first_name': widget.lmsGameDetails.userProfile.firstName,
        'last_name': widget.lmsGameDetails.userProfile.lastName,
        'buy_in_amount': widget.lmsGameDetails.league.buyIn,
      });
      setState(() {
        _isLoading = false;
      });
      final depositResult = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.35,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Not Enough Money',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text.rich(
                  TextSpan(
                    text:
                        'You do not have enough funds to pay the buy-in. Please ',
                    style: TextStyle(fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'add more funds',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' to continue.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Log event for deposit money flow.
                      getIt<FirebaseAnalyticsService>()
                          .logEvent('deposit_money_tap', parameters: {
                        'league_id': widget.lmsGameDetails.league.leagueId,
                        'username': widget.lmsGameDetails.userProfile.username,
                      });
                      final result = await context.push<bool>(
                        Routes.depositMoney.path,
                        extra: widget.lmsGameDetails.userProfile,
                      );
                      Navigator.of(context).pop(result);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Deposit Money',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: UnderlinedTextStack(
                      text: 'Cancel',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      textColor: Colors.black,
                      underlineColor: Colors.black,
                      underlineThickness: 7.0,
                      spacing: 6.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (depositResult == true) {
        // Log deposit success event.
        getIt<FirebaseAnalyticsService>()
            .logEvent('deposit_money_success', parameters: {
          'league_id': widget.lmsGameDetails.league.leagueId,
          'username': widget.lmsGameDetails.userProfile.username,
        });
        Navigator.of(context).pop(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final buyIn =
        '£${widget.lmsGameDetails.league.buyIn?.toStringAsFixed(2) ?? '0.00'}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Pay Buy-In to Join League',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'To join the league and make your selection, please pay ',
                style: const TextStyle(fontSize: 13),
                children: <TextSpan>[
                  TextSpan(
                    text: buyIn,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' as your buy-in amount.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _payBuyin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Pay Buy-In',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: UnderlinedTextStack(
                  text: 'Cancel',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.black,
                  underlineColor:
                      Theme.of(context).textTheme.bodyMedium?.color ??
                          Colors.black,
                  underlineThickness: 7.0,
                  spacing: 6.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
