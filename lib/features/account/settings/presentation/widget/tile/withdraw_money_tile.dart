import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';

class WithdrawMoneyTile extends StatelessWidget {
  final UserProfileEntity profile;

  const WithdrawMoneyTile({
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
              await context.push(Routes.withdrawMoney.path, extra: profile);
          if (result == true) {
            context.read<ProfileCubit>().fetchProfile();
          }
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          minimumSize: const Size(0, 0),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   Icons.remove_circle,
            //   size: 18,
            // ),
            SizedBox(width: 4),
            Text(
              'Withdraw',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold), // Set text color
            ),
          ],
        ),
      ),
    );
  }
}
