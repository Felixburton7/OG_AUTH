import 'package:flutter/material.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/widgets/form_wrapper.dart';
import 'package:panna_app/features/account/settings/presentation/widget/button/change_email_address_button.dart';
import 'package:panna_app/features/account/settings/presentation/widget/input/change_email_adress_email_input.dart';

class ChangeEmailAddressForm extends StatelessWidget {
  const ChangeEmailAddressForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Change email address",
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: Spacing.s16),
              const Text(
                "You will be required to confirm an email change to new email address.",
                softWrap: true,
              ),
              const SizedBox(height: Spacing.s16),
              const ChangeEmailAddressEmailInput(),
              const SizedBox(height: Spacing.s16),
              const ChangeEmailAddressButton(),
            ],
          ),
        ),
      ),
    );
  }
}
