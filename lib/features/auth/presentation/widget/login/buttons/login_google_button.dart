import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/widgets/form_button.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/auth/data/repository/supabase_auth_repository.dart';
import 'package:panna_app/features/auth/domain/use_case/login_with_google_use_case.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:panna_app/core/constants/urls.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/auth/data/mapper/auth_mapper.dart';
import 'package:panna_app/features/auth/domain/entity/auth_user_entity.dart';
import 'package:panna_app/features/auth/domain/exception/login_with_email_exception.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

class LoginWithGoogleButton extends StatelessWidget {
  const LoginWithGoogleButton({
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
                    context.read<LoginCubit>().loginWithGoogle();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),

              // ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.g_mobiledata_rounded),
                SizedBox(width: 10),
                Text(
                  'Continue with Google',
                  style: TextStyle(
                      fontSize: FontSize.s14, fontWeight: FontWeight.bold),
                ),
              ],
            ));
      },
    );
  }
}
