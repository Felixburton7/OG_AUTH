import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/utils/team_name_helper.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/head_to_head/domain/entities/h2h_game_details.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_bloc.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_event.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/bloc/bloc/bet_offer_state.dart';
import 'package:panna_app/features/leagues/head_to_head/presentation/page/head_to_head_create_bet_offer_page.dart';

// class HeadToHeadBetslip extends StatefulWidget {
//   final String fixtureId;
//   final String teamName;
//   final double odds;
//   final H2hGameDetails h2hGameDetails;

//   const HeadToHeadBetslip({
//     Key? key,
//     required this.fixtureId,
//     required this.teamName,
//     required this.odds,
//     required this.h2hGameDetails,
//   }) : super(key: key);

//   @override
//   State<HeadToHeadBetslip> createState() => _HeadToHeadBetslipState();
// }

// class _HeadToHeadBetslipState extends State<HeadToHeadBetslip> {
//   final TextEditingController _stakeController = TextEditingController();
//   final FocusNode _stakeFocusNode = FocusNode();
//   double _stakeAmount = 0;
//   late final BetOfferBloc _betOfferBloc;
//   bool _keyboardVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     _stakeController.addListener(_updateStakeAmount);
//     _betOfferBloc = getIt<BetOfferBloc>();
//   }

//   @override
//   void dispose() {
//     _stakeController.removeListener(_updateStakeAmount);
//     _stakeController.dispose();
//     _stakeFocusNode.dispose();
//     super.dispose();
//   }

//   void _updateStakeAmount() {
//     final String text = _stakeController.text;
//     if (text.isEmpty) {
//       setState(() {
//         _stakeAmount = 0;
//       });
//       return;
//     }
//     setState(() {
//       _stakeAmount = double.tryParse(text) ?? 0;
//     });
//   }

//   FixtureEntity? _getFixture() {
//     return widget.h2hGameDetails.fixtures.firstWhere(
//       (fixture) => fixture.fixtureId == widget.fixtureId,
//       orElse: () => const FixtureEntity(),
//     );
//   }

//   String _formatMatchTime(DateTime? dateTime) {
//     if (dateTime == null) return "TBD";
//     return AppUtils.formatFixtureTime(dateTime);
//   }

//   String _getTeamId() {
//     final fixture = _getFixture();
//     if (fixture == null) return "";
//     if (widget.teamName == fixture.homeTeamName) {
//       return fixture.homeTeamId ?? "";
//     } else if (widget.teamName == fixture.awayTeamName) {
//       return fixture.awayTeamId ?? "";
//     }
//     return "";
//   }

//   void _placeBet() {
//     FocusScope.of(context).unfocus();

//     if (_stakeAmount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid stake amount')),
//       );
//       return;
//     }
//     if (_stakeAmount > widget.h2hGameDetails.profileAccountBalance) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Insufficient balance to place this bet')),
//       );
//       return;
//     }
//     final fixture = _getFixture();
//     if (fixture == null || fixture.fixtureId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Fixture information not available')),
//       );
//       return;
//     }
//     final teamId = _getTeamId();
//     if (teamId.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Team information not available')),
//       );
//       return;
//     }
//     final deadline = fixture.startTime?.subtract(const Duration(minutes: 5)) ??
//         DateTime.now().add(const Duration(days: 1));

//     // Send traditional multiplier to backend (stored odds + 2.0)
//     _betOfferBloc.add(
//       CreateBetOfferEvent(
//         fixtureId: fixture.fixtureId!,
//         teamId: teamId,
//         gameweekId: widget.h2hGameDetails.currentGameweekId,
//         leagueId: widget.h2hGameDetails.leagueId,
//         odds: widget.odds + 2.0,
//         stakeAmount: _stakeAmount,
//         deadline: deadline,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fixture = _getFixture();
//     final String homeTeam = fixture?.homeTeamName ?? "Home Team";
//     final String awayTeam = fixture?.awayTeamName ?? "Away Team";
//     final String matchupTitle = "$homeTeam vs $awayTeam";
//     final String matchTime = _formatMatchTime(fixture?.startTime);
//     final double multiplier = widget.odds + 2.0;
//     // For fraction display, pass (multiplier - 1.0)
//     final String fractionOdds = AppUtils.decimalToFraction(multiplier - 1.0);
//     final double returnAmount = _stakeAmount * multiplier;
//     final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

//     return BlocProvider.value(
//       value: _betOfferBloc,
//       child: BlocListener<BetOfferBloc, BetOfferState>(
//         listener: (context, state) {
//           if (state is BetOfferCreationSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//             Navigator.pop(context, {
//               'success': true,
//               'bet': state.betOffer,
//             });
//           } else if (state is BetOfferCreationFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error)),
//             );
//           }
//         },
//         child: BlocBuilder<BetOfferBloc, BetOfferState>(
//           builder: (context, state) {
//             final bool isPlacingBet = state is BetOfferCreating;
//             return Container(
//               height: MediaQuery.of(context).size.height * 0.8,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               child: GestureDetector(
//                 onTap: () => FocusScope.of(context).unfocus(),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 5,
//                       margin: const EdgeInsets.only(top: 16, bottom: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                         child: ListView(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     matchupTitle,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color:
//                                         AppColors.primaryGreen.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     "${multiplier.toStringAsFixed(1)}",
//                                     style: const TextStyle(
//                                       color: AppColors.darkGreen,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 4.0),
//                               child: Text(
//                                 matchTime,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               "${widget.teamName.toUpperCase()} TO WIN",
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 4.0),
//                               child: Text(
//                                 "You have selected ${widget.teamName} to WIN",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               "Bet conditions",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(top: 8.0, bottom: 16.0),
//                               child: Text(
//                                 "If your bet wins, you win the total pot. If your team loses or draws, "
//                                 "the pot goes to whoever's bet you accept. If you want to accept "
//                                 "more than one bet, you must buy-in once again.",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[600],
//                                   height: 1.5,
//                                 ),
//                               ),
//                             ),
//                             const Divider(),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 16.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     "New bet",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   Text(
//                                     "${multiplier.toStringAsFixed(1)}",
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[200],
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: TextField(
//                                       controller: _stakeController,
//                                       focusNode: _stakeFocusNode,
//                                       keyboardType:
//                                           const TextInputType.numberWithOptions(
//                                               decimal: true),
//                                       decoration: const InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: "£0",
//                                         labelText: "Stake",
//                                       ),
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.allow(
//                                             RegExp(r'^\d+\.?\d{0,2}')),
//                                       ],
//                                       enabled: !isPlacingBet,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         "Returns from 1 bet acceptance",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         "£${returnAmount.toStringAsFixed(2)}",
//                                         style: const TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: keyboardVisible ? 100 : 24),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(
//                         left: 24,
//                         right: 24,
//                         bottom: keyboardVisible ? 16 : 24,
//                         top: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border(
//                           top: BorderSide(
//                             color: Colors.grey[300]!,
//                             width: 1,
//                           ),
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.85,
//                             child: ElevatedButton(
//                               onPressed: isPlacingBet || _stakeAmount <= 0
//                                   ? null
//                                   : _placeBet,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.primaryGreen,
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 disabledBackgroundColor: Colors.grey[400],
//                               ),
//                               child: isPlacingBet
//                                   ? const SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                         strokeWidth: 2,
//                                       ),
//                                     )
//                                   : const Text(
//                                       "PLACE BET",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               "Balance: £${widget.h2hGameDetails.profileAccountBalance.toStringAsFixed(2)}",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
class HeadToHeadBetslip extends StatefulWidget {
  final String fixtureId;
  final String teamName;
  final double odds;
  final H2hGameDetails h2hGameDetails;

  const HeadToHeadBetslip({
    Key? key,
    required this.fixtureId,
    required this.teamName,
    required this.odds,
    required this.h2hGameDetails,
  }) : super(key: key);

  @override
  State<HeadToHeadBetslip> createState() => _HeadToHeadBetslipState();
}

class _HeadToHeadBetslipState extends State<HeadToHeadBetslip> {
  final TextEditingController _stakeController = TextEditingController();
  final FocusNode _stakeFocusNode = FocusNode();
  double _stakeAmount = 0;
  late final BetOfferBloc _betOfferBloc;
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _stakeController.addListener(_updateStakeAmount);
    _betOfferBloc = getIt<BetOfferBloc>();
  }

  @override
  void dispose() {
    _stakeController.removeListener(_updateStakeAmount);
    _stakeController.dispose();
    _stakeFocusNode.dispose();
    super.dispose();
  }

  void _updateStakeAmount() {
    final String text = _stakeController.text;
    if (text.isEmpty) {
      setState(() {
        _stakeAmount = 0;
      });
      return;
    }
    setState(() {
      _stakeAmount = double.tryParse(text) ?? 0;
    });
  }

  FixtureEntity? _getFixture() {
    return widget.h2hGameDetails.fixtures.firstWhere(
      (fixture) => fixture.fixtureId == widget.fixtureId,
      orElse: () => const FixtureEntity(),
    );
  }

  String _formatMatchTime(DateTime? dateTime) {
    if (dateTime == null) return "TBD";
    return AppUtils.formatFixtureTime(dateTime);
  }

  String _getTeamId() {
    final fixture = _getFixture();
    if (fixture == null) return "";
    if (widget.teamName == fixture.homeTeamName) {
      return fixture.homeTeamId ?? "";
    } else if (widget.teamName == fixture.awayTeamName) {
      return fixture.awayTeamId ?? "";
    }
    return "";
  }

  void _placeBet() {
    FocusScope.of(context).unfocus();

    if (_stakeAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid stake amount')),
      );
      return;
    }
    if (_stakeAmount > widget.h2hGameDetails.profileAccountBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient balance to place this bet')),
      );
      return;
    }
    final fixture = _getFixture();
    if (fixture == null || fixture.fixtureId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fixture information not available')),
      );
      return;
    }
    final teamId = _getTeamId();
    if (teamId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team information not available')),
      );
      return;
    }
    final deadline = fixture.startTime?.subtract(const Duration(minutes: 5)) ??
        DateTime.now().add(const Duration(days: 1));

    // For backend calculations, send the multiplier as (widget.odds + 2.0)
    _betOfferBloc.add(
      CreateBetOfferEvent(
        fixtureId: fixture.fixtureId!,
        teamId: teamId,
        gameweekId: widget.h2hGameDetails.currentGameweekId,
        leagueId: widget.h2hGameDetails.leagueId,
        odds: widget.odds + 2.0,
        stakeAmount: _stakeAmount,
        deadline: deadline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fixture = _getFixture();
    final String homeTeam = fixture?.homeTeamName ?? "Home Team";
    final String awayTeam = fixture?.awayTeamName ?? "Away Team";
    final String matchupTitle = "$homeTeam vs $awayTeam";
    final String matchTime = _formatMatchTime(fixture?.startTime);

    // Display the original odd (e.g., 1.0) in the betslip UI
    final double originalDecimal = widget.odds + 1.0;
    // Multiplier used for return calculations (e.g., 1.0 becomes 2.0)
    final double multiplier = widget.odds + 2.0;
    // This converts originalDecimal into a fraction (e.g., 1.0 -> 2/1)
    final String fractionOdds = AppUtils.decimalToFraction(multiplier - 1.0);
    final double returnAmount = _stakeAmount * multiplier;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Compute the bet factor for the "New bet" row.
    // For example, if multiplier is 2.0, betFactor becomes "x2".
    final String betFactor = "x" +
        (multiplier.truncateToDouble() == multiplier
            ? multiplier.toStringAsFixed(0)
            : multiplier.toStringAsFixed(1));

    return BlocProvider.value(
      value: _betOfferBloc,
      child: BlocListener<BetOfferBloc, BetOfferState>(
        listener: (context, state) {
          if (state is BetOfferCreationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context, {
              'success': true,
              'bet': state.betOffer,
            });
          } else if (state is BetOfferCreationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<BetOfferBloc, BetOfferState>(
          builder: (context, state) {
            final bool isPlacingBet = state is BetOfferCreating;
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(top: 16, bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    matchupTitle,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryGreen.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // Top right corner shows the original odd (e.g., "1.0")
                                  child: Text(
                                    "${originalDecimal.toStringAsFixed(1)}",
                                    style: const TextStyle(
                                      color: AppColors.darkGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                matchTime,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "${widget.teamName.toUpperCase()} TO WIN",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "You have selected ${widget.teamName} to WIN",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Bet conditions",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 16.0),
                              child: Text(
                                "If your bet wins, you win the total pot. If your team loses or draws, "
                                "the pot goes to whoever's bet you accept. If you want to accept "
                                "more than one bet, you must buy-in once again.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const Divider(),
                            // Updated "New bet" row now shows the bet factor (e.g. "x2")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "New bet",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    betFactor,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: _stakeController,
                                      focusNode: _stakeFocusNode,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "£0",
                                        labelText: "Stake",
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      enabled: !isPlacingBet,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Returns from 1 bet acceptance",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Use the multiplier for return calculations
                                      Text(
                                        "£${returnAmount.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: keyboardVisible ? 100 : 24),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: keyboardVisible ? 16 : 24,
                        top: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: ElevatedButton(
                              onPressed: isPlacingBet || _stakeAmount <= 0
                                  ? null
                                  : _placeBet,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                disabledBackgroundColor: Colors.grey[400],
                              ),
                              child: isPlacingBet
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "PLACE BET",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Balance: £${widget.h2hGameDetails.profileAccountBalance.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
