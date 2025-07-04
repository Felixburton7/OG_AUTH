import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/widgets/form_button.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';

class LoginWithEmailButton extends StatelessWidget {
  const LoginWithEmailButton({
    super.key,
    required this.isEnabled,
  });

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return FormButton(
          onPressed: isEnabled
              ? () {
                  context.closeKeyboard();
                  context.read<LoginCubit>().submitEmailForm();
                }
              : null,
          decoration: BoxDecoration(
            color:
                isEnabled ? Theme.of(context).colorScheme.primary : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email),
              SizedBox(width: 10),
              Text(
                'Continue with email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
