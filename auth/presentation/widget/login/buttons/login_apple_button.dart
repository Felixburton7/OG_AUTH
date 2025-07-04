import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/widgets/form_button.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';

class LoginWithAppleButton extends StatelessWidget {
  const LoginWithAppleButton({
    super.key,
    required this.isEnabled,
  });

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return OutlinedButton(
            onPressed: isEnabled
                ? () {
                    context.closeKeyboard();
                    context.read<LoginCubit>().submitEmailForm();
                  }
                : null,
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.apple),
                SizedBox(width: 10),
                Text(
                  'Continue with Apple',
                  style: TextStyle(
                      fontSize: FontSize.s14, fontWeight: FontWeight.bold),
                ),
              ],
            ));
      },
    );
  }
}
