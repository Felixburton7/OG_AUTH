// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:panna_app/core/widgets/textfields/password_text_field.dart';
// import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';

// class LoginWithPasswordInput extends StatelessWidget {
//   const LoginWithPasswordInput({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.email != current.email,
//       builder: (context, state) {
//         return PasswordTextField(
//           onChanged: (password) =>
//               context.read<LoginCubit>().passwordChanged(password),
//           textInputAction: TextInputAction.done,
//           errorText:
//               state.email.displayError != null ? "Invalid password" : null,
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:panna_app/core/widgets/textfields/password_text_field.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';

class LoginWithPasswordInput extends StatelessWidget {
  const LoginWithPasswordInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return PasswordTextField(
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          textInputAction: TextInputAction.done,
          errorText:
              state.password.displayError != null ? "Invalid password" : null,
        );
      },
    );
  }
}
