import 'package:flutter/material.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/widgets/form_wrapper.dart';
import 'package:panna_app/features/account/settings/presentation/widget/button/update_password_button.dart';
import 'package:panna_app/features/account/settings/presentation/widget/input/confirm_password_input.dart';
import 'package:panna_app/features/account/settings/presentation/widget/input/update_password_input.dart';

class UpdatePasswordForm extends StatelessWidget {
  const UpdatePasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FormWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PasswordInput(),
          SizedBox(height: Spacing.s16),
          ConfirmPasswordInput(),
          SizedBox(height: Spacing.s16),
          UpdatePasswordButton(),
        ],
      ),
    );
  }
}
