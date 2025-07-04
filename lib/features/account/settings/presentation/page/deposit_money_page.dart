import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/form/deposit_money_form.dart';

class DepositMoneyPage extends StatelessWidget {
  final UserProfileEntity profile;

  const DepositMoneyPage({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
        create: (context) => getIt<ProfileCubit>(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Deposit Money'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.s16),
              child: BlocListener<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileUpdated) {
                    context
                        .showSnackBarMessage("Profile successfully updated.");
                  } else if (state is ProfileError) {
                    context.showErrorSnackBarMessage(state.message);
                  }
                },
                child: DepositMoneyForm(profile: profile),
              ),
            ),
          ),
        ));
  }
}
