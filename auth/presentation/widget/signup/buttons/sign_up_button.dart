import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/widgets/centered_circular_progress_indicator.dart';
import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart';
import 'package:formz/formz.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        // Check if the form is in progress (submitting) or invalid, disable the button in these cases
        final isButtonEnabled = state.isValid && !state.status.isInProgress;

        return ElevatedButton(
          onPressed: isButtonEnabled
              ? () {
                  context.closeKeyboard();

                  // Prevent multiple submissions by checking the state again before submitting
                  if (!state.status.isInProgress) {
                    context.read<SignUpCubit>().submitForm();
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Increase border radius
            ),
          ),
          child: state.status.isInProgress
              ? const CenteredCircularProgressIndicator()
              : const Text('Next'),
        );
      },
    );
  }
}
