import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:formz/formz.dart';
import 'package:panna_app/features/account/settings/presentation/widget/form/reset_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ResetPasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Forgot password?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.s24),
            child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
              listener: (context, state) {
                if (state.status.isFailure && state.email.isValid) {
                  context.showErrorSnackBarMessage(
                    state.errorMessage ?? "An unknown error occurred.",
                  );
                } else if (state.status.isSuccess) {
                  context.showSnackBarMessage(
                    "Password reset email has been sent. Please check your email.",
                  );

                  // Navigate to Check Your Email Page
                  context.pushReplacement(
                      '/check-your-email'); // Define this route in your GoRouter setup
                }
              },
              child: const ForgotPasswordForm(),
            ),
          ),
        ),
      ),
    );
  }
}
// // forgot_password_page.dart

// class ForgotPasswordPage extends StatelessWidget {
//   const ForgotPasswordPage({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => getIt<ResetPasswordCubit>(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Forgot password?',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(Spacing.s24),
//             child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
//               listener: (context, state) {
//                 if (state.status.isFailure && state.email.isValid) {
//                   context.showErrorSnackBarMessage(
//                     state.errorMessage ?? "An unknown error occurred.",
//                   );
//                 } else if (state.status.isSuccess) {
//                   context.showSnackBarMessage(
//                     "Password reset email has been sent. This may take up to 3 minutes",
//                   );
//                 }
//               },
//               child: const ForgotPasswordForm(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
