import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_password/update_password_cubit.dart';

class ConfirmPasswordInput extends StatelessWidget {
  const ConfirmPasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
      buildWhen: (previous, current) =>
          previous.confirmedPassword != current.confirmedPassword ||
          previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (confirmPassword) => context
              .read<UpdatePasswordCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            errorText: state.confirmedPassword.isNotValid &&
                    state.confirmedPassword.isNotValid
                ? 'Passwords do not match'
                : null,
          ),
        );
      },
    );
  }
}
