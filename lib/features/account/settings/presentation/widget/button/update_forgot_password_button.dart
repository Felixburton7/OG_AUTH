import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_forgot_password_cubit/update_forgot_password_cubit.dart';

class UpdateForgotPasswordButton extends StatelessWidget {
  const UpdateForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateForgotPasswordCubit, UpdateForgotPasswordState>(
      builder: (context, state) {
        if (state.status == FormzSubmissionStatus.inProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: state.isValid
              ? () {
                  context.read<UpdateForgotPasswordCubit>().submitForm();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: const Text('Update Password'),
        );
      },
    );
  }
}
