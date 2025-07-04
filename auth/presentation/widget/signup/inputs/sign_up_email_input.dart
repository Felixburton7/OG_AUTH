import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/widgets/textfields/email_text_field.dart';
import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart';

class SignUpEmailInput extends StatelessWidget {
  const SignUpEmailInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return EmailTextField(
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          textInputAction: TextInputAction.next,
          errorText:
              state.email.displayError != null ? "Invalid email address" : null,
        );
      },
    );
  }
}
