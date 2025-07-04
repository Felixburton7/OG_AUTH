import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/widgets/form_wrapper.dart';
import 'package:panna_app/core/widgets/textfields/email_text_field.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/reset_password/reset_password_cubit.dart';

// forgot_password_form.dart

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const FormWrapper(
      // child: Align(
      // alignment: const Alignment(0, -1 / 3),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text(
            //   "Forgot Password",
            //   style: context.textTheme.headlineLarge,
            // ),
            // const SizedBox(height: Spacing.s16),
            Text(
              "Enter your email address and we'll send you a link to reset your password.",
              softWrap: true,
            ),
            SizedBox(height: Spacing.s16),
            ForgotPasswordEmailInput(),
            SizedBox(height: Spacing.s16),
            ForgotPasswordButton(),
          ],
        ),
      ),
    );
    // );
  }
}

class ForgotPasswordEmailInput extends StatefulWidget {
  const ForgotPasswordEmailInput({super.key});

  @override
  _ForgotPasswordEmailInputState createState() =>
      _ForgotPasswordEmailInputState();
}

class _ForgotPasswordEmailInputState extends State<ForgotPasswordEmailInput> {
  final FocusNode _focusNode = FocusNode();
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    // Listen for when the focus changes (loses focus)
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _hasInteracted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return EmailTextField(
          onChanged: (email) =>
              context.read<ResetPasswordCubit>().emailChanged(email),
          textInputAction: TextInputAction.done,
          errorText: _hasInteracted &&
                  state.email.isNotValid &&
                  state.email.value.isNotEmpty
              ? "Invalid email address"
              : null,
        );
      },
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        if (state.status == FormzSubmissionStatus.inProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: state.email.isValid
              ? () {
                  context.closeKeyboard();
                  context.read<ResetPasswordCubit>().submitForm();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: const Text('Send instructions'),
        );
      },
    );
  }
}
