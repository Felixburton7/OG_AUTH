import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';

class DepositMoneyTile extends StatelessWidget {
  final UserProfileEntity profile;

  const DepositMoneyTile({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: () async {
          final result =
              await context.push(Routes.depositMoney.path, extra: profile);
          if (result == true) {
            context.read<ProfileCubit>().fetchProfile();
          }
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white, // sets text and icon color
          padding: const EdgeInsets.symmetric(horizontal: 15),
          minimumSize: const Size(0, 0),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   Icons.add_circle,
            //   size: 18,
            // ),
            const SizedBox(width: 4),
            Text(
              'Add Money',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
