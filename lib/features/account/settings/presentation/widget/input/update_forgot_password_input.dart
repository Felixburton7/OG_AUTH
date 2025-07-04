import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_forgot_password_cubit/update_forgot_password_cubit.dart';

class UpdateForgotPasswordInput extends StatelessWidget {
  const UpdateForgotPasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateForgotPasswordCubit, UpdateForgotPasswordState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) => context
              .read<UpdateForgotPasswordCubit>()
              .passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'New Password',
            errorText: state.password.isNotValid && state.password.isPure
                ? 'Password must be at least 6 characters'
                : null,
          ),
        );
      },
    );
  }
}
