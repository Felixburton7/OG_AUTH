import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/widgets/form_wrapper.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_forgot_password_cubit/update_forgot_password_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/button/update_forgot_password_button.dart';
import 'package:panna_app/features/account/settings/presentation/widget/input/confirm_update_forgot_password_input.dart';
import 'package:panna_app/features/account/settings/presentation/widget/input/update_forgot_password_input.dart';

class UpdateForgotPasswordForm extends StatelessWidget {
  const UpdateForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateForgotPasswordCubit, UpdateForgotPasswordState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          // Navigate to login or signup page after successful password reset
          context.push(Routes.loginOrSignup.path);
        } else if (state.status == FormzSubmissionStatus.failure) {
          // Show error message on failure
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Password reset failed. Please try again.')),
          );
        }
      },
      builder: (context, state) {
        return const FormWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UpdateForgotPasswordInput(), // New password input
              SizedBox(height: Spacing.s16),
              ConfirmUpdateForgotPasswordInput(), // Confirm password input
              SizedBox(height: Spacing.s16),
              UpdateForgotPasswordButton(), // Submit button
            ],
          ),
        );
      },
    );
  }
}
