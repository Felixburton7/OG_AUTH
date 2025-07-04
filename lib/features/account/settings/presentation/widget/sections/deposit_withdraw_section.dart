import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/deposit_money_tile.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/withdraw_money_tile.dart';

class DepositWithdrawSection extends StatelessWidget {
  final UserProfileEntity profile;

  const DepositWithdrawSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final updatedProfile = state is ProfileLoaded ? state.profile : profile;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 44, 182, 85).withOpacity(0.09),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top left "Wallet balance"
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Wallet balance',
                      style: TextStyle(
                        fontSize: FontSize.s18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Centered wallet balance display

                  Text(
                    '£ ${updatedProfile.accountBalance}',
                    style: const TextStyle(
                      fontSize: FontSize.s36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Deposit and Withdraw tiles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DepositMoneyTile(profile: updatedProfile),
                      const SizedBox(width: 10),
                      WithdrawMoneyTile(profile: updatedProfile),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
