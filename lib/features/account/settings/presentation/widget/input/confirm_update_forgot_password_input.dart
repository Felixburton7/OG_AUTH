import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_forgot_password_cubit/update_forgot_password_cubit.dart';

class ConfirmUpdateForgotPasswordInput extends StatelessWidget {
  const ConfirmUpdateForgotPasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    r// confirm_update_forgot_password_input.dart
return BlocBuilder<UpdateForgotPasswordCubit, UpdateForgotPasswordState>(
  buildWhen: (previous, current) =>
      previous.confirmedPassword != current.confirmedPassword ||  // ← use “confirmedPassword”
      previous.password != current.password,
  builder: (context, state) {
    return TextField(
      onChanged: (value) => context
          .read<UpdateForgotPasswordCubit>()
          .confirmedPasswordChanged(value),  // ← same naming
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorText: state.confirmedPassword.invalid  // Formz exposes `invalid`
            ? 'Passwords do not match'
            : null,
      ),
    );
  },
);
  }
}
