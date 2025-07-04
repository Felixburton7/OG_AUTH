import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/widgets/form_wrapper.dart';
import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart';
import 'package:panna_app/features/auth/presentation/widget/signup/buttons/sign_up_button.dart';
import 'package:panna_app/features/auth/presentation/widget/signup/inputs/sign_up_email_input.dart';

import '../signup/inputs/sign_up_password_input copy.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      child: Align(
        alignment: const Alignment(0, -3 / 3),
        child: SingleChildScrollView(
          child: BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Center(
                  //   child: Text(
                  //     "Create an account",
                  //     style: context.textTheme.displayLarge,
                  //     softWrap: true,
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  const SizedBox(height: Spacing.s8),
                  state.isEmailStep
                      ? _buildEmailStep(context)
                      : _buildPasswordStep(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "What's your email?",
              style: context.textTheme.displayMedium,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: Spacing.s16),
        const SignUpEmailInput(),
        const SizedBox(height: Spacing.s16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "You'll need to confirm this email later",
              style: context.textTheme.labelMedium,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: Spacing.s16),
        ElevatedButton(
          onPressed: () {
            if (context.read<SignUpCubit>().state.email.isValid) {
              context.read<SignUpCubit>().moveToPasswordStep();
            } else {
              context.showErrorSnackBarMessage("Please enter a valid email");
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  30.0), // Adjust the value to make it rounder
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildPasswordStep(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Create a password",
              style: context.textTheme.displayMedium,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: Spacing.s16),
        const SignUpPasswordInput(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.s4),
            Text(
              "  Use at least 6 characters",
              style: context.textTheme.labelMedium,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: Spacing.s16),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the buttons horizontally
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100, // Set the desired width for the back button
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  context.read<SignUpCubit>().moveToEmailStep();
                },
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: Spacing.s16),
            const SizedBox(
              width: 100, // Set the desired width for the sign-up button
              child: SignUpButton(),
            ),
          ],
        ),
      ],
    );
  }
}
