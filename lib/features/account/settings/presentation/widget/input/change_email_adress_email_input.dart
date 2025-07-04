import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/widgets/textfields/email_text_field.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/change_email_address/change_email_address_cubit.dart';

class ChangeEmailAddressEmailInput extends StatelessWidget {
  const ChangeEmailAddressEmailInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeEmailAddressCubit, ChangeEmailAddressState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return EmailTextField(
          onChanged: (email) =>
              context.read<ChangeEmailAddressCubit>().emailChanged(email),
          textInputAction: TextInputAction.done,
          errorText:
              state.email.displayError != null ? "Invalid email address" : null,
        );
      },
    );
  }
}
