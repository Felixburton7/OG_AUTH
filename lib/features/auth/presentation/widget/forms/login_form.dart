import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/widgets/form_wrapper.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:panna_app/features/auth/presentation/widget/login/inputs/login_email_input.dart';
import 'package:panna_app/features/auth/presentation/widget/login/inputs/login_email_password_input.dart';
import 'package:panna_app/features/auth/presentation/widget/login/buttons/login_password_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
        child: Align(
            alignment: const Alignment(0, -4.2 / 3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Spacing.s48),
                  const LoginEmailInput(),
                  const SizedBox(height: Spacing.s16),
                  const LoginWithPasswordInput(),
                  const SizedBox(height: Spacing.s16),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          LoginButtonPassword(
                              isEnabled: state.email.isValid &&
                                  state.password.isValid),
                          const SizedBox(height: Spacing.s16),
                          TextButton(
                            onPressed: () {
                              context.push(Routes.signUp.path);
                            },
                            child: const Text(
                              "Don't have an account? Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(Routes.forgotPassword.path);
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // LoginWithEmailButton(isEnabled: state.email.isValid),
                          // const SizedBox(height: 10),
                          // LoginWithAppleButton(isEnabled: false),
                          // const SizedBox(height: 10),
                          // LoginWithGoogleButton(isEnabled: false),
                        ],
                      );
                    },
                  )
                ],
              ),
            )));
  }
}
          

            
          
            
      

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:panna_app/core/constants/spacings.dart';
// import 'package:panna_app/core/extensions/build_context_extensions.dart';
// import 'package:panna_app/core/router/routes.dart';
// import 'package:panna_app/core/widgets/form_wrapper.dart';
// import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';
// import 'package:panna_app/features/auth/presentation/widget/login/login_email_button.dart';
// import 'package:panna_app/features/auth/presentation/widget/login/login_email_input.dart';
// import 'package:panna_app/features/auth/presentation/widget/login/login_email_password_input.dart';
// import 'package:panna_app/features/auth/presentation/widget/login/login_password_button.dart';

// class LoginForm extends StatelessWidget {
//   const LoginForm({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FormWrapper(
//       child: Align(
//         alignment: const Alignment(0, -1 / 3),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Center(
//                 child: Text(
//                   "Let's get started!!!",
//                   style: context.textTheme.displayLarge,
//                   softWrap: true,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: Spacing.s8),
//               Center(
//                 child: Text(
//                   "Please enter your email address to continue.",
//                   style: context.textTheme.displayMedium,
//                   softWrap: true,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: Spacing.s48),
//               const LoginEmailInput(),
//               const SizedBox(height: Spacing.s16),
//               const LoginWithPasswordInput(),
//               const SizedBox(height: Spacing.s16),
//               const LoginButtonPassword(),
//               const SizedBox(height: Spacing.s16),
//               TextButton(
//                 onPressed: () {
//                   context.go(Routes.home.path);
//                 },
//                 child: const Text("Don't have an account? Sign up"),
//               ),
//               const SizedBox(height: Spacing.s16),
//               const LoginWithEmailButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }