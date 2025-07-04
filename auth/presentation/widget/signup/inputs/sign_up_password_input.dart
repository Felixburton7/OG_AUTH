import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/widgets/textfields/password_text_field.dart';
import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart';

class SignUpDateOfBirthInput extends StatelessWidget {
  const SignUpDateOfBirthInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return PasswordTextField(
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          textInputAction: TextInputAction.done,
          errorText:
              state.password.displayError != null ? "Invalid password" : null,
        );
      },
    );
  }
}
