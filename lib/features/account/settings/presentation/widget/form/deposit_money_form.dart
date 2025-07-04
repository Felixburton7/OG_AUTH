import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';

class DepositMoneyForm extends StatefulWidget {
  final UserProfileEntity profile;

  const DepositMoneyForm({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _DepositMoneyFormState createState() => _DepositMoneyFormState();
}

class _DepositMoneyFormState extends State<DepositMoneyForm> {
  late double _accountBalanceNumber;

  @override
  void initState() {
    super.initState();
    _accountBalanceNumber = widget.profile.accountBalance;
  }

  void _depositAmount(double amount) async {
    final updatedBalance = _accountBalanceNumber + amount;

    final updatedProfile = UserProfileDTO(
      profileId: widget.profile.profileId,
      accountBalance: updatedBalance,
      teamSupported: widget.profile.teamSupported,
      firstName: widget.profile.firstName,
      lastName: widget.profile.lastName,
      username: widget.profile.username,
      avatarUrl: widget.profile.avatarUrl,
      lmsAverage: widget.profile.lmsAverage,
      dateOfBirth: widget.profile.dateOfBirth,
      bio: widget.profile.bio,
    );

    // Update profile and wait for completion
    await context.read<ProfileCubit>().updateProfile(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          // Navigate back to the account page
          Navigator.pop(context, true);
        } else if (state is ProfileError) {
          // Show error message
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is ProfileUpdating) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'Your Wallet',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              // Wallet Balance Card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'Total Credits',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_accountBalanceNumber.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Features List with Icons next to Titles
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Text('Payment integration coming soon!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20)),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 8, 20),
                    child: Text('What to expect:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16)),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fast and Secure Deposits',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Easily add funds to your account to bet across multiple games.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Second Feature
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.emoji_events),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Flexible Winnings',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Withdraw when you want, and instantly use your winnings for future bets.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Third Feature
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.account_balance_wallet),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet Stats',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Track your wins across all your games for the season.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              // Deposit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _depositAmount(10.0); // Deposit £10
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary, // Green color for deposit
                  ),
                  child: Text(
                    'Add 10 credits',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
