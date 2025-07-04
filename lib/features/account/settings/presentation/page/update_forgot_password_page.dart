import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_forgot_password_cubit/update_forgot_password_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/form/update_forgot_password.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/account/settings/presentation/cubit/update_forgot_password_cubit/update_forgot_password_cubit.dart';
import 'package:panna_app/features/account/settings/presentation/widget/form/update_forgot_password.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';

class UpdateForgotPasswordPage extends StatefulWidget {
  final String? token;

  const UpdateForgotPasswordPage({Key? key, this.token}) : super(key: key);

  @override
  State<UpdateForgotPasswordPage> createState() =>
      _UpdateForgotPasswordPageState();
}

class _UpdateForgotPasswordPageState extends State<UpdateForgotPasswordPage> {
  @override
  void initState() {
    super.initState();

    // Get token either from widget or from AuthBloc state
    String? recoveryToken = widget.token;

    if (recoveryToken == null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthPasswordRecovery) {
        recoveryToken = authState.token;
      }
    }

    // If token is available, pass it to the cubit
    if (recoveryToken != null) {
      context.read<UpdateForgotPasswordCubit>().setToken(recoveryToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.s16),
        child: BlocProvider(
          create: (context) => getIt<UpdateForgotPasswordCubit>(),
          child: const UpdateForgotPasswordForm(),
        ),
      ),
    );
  }
}
// class UpdateForgotPasswordPage extends StatelessWidget {
//   const UpdateForgotPasswordPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _AuthBlocListener(
//       child: BlocProvider(
//         create: (context) => getIt<UpdateForgotPasswordCubit>(),
//         child:
//             BlocListener<UpdateForgotPasswordCubit, UpdateForgotPasswordState>(
//           listener: (context, state) {
//             if (state.status.isSuccess && state.navigateToLogin) {
//               context.push(
//                   Routes.loginOrSignup.path); // Navigate back to login page
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Password successfully updated')),
//               );
//             }
//           },
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text('Reset Your Password'),
//               automaticallyImplyLeading: false,
//             ),
//             body: const SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: UpdateForgotPasswordForm(), // Your password form here
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _AuthBlocListener extends StatelessWidget {
  const _AuthBlocListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) async {
        if (state is AuthUserAuthenticated) {
          // Perform the sign out operation and wait for it to complete
          await Supabase.instance.client.auth.signOut();

          // After sign out is complete, navigate to login/signup page
          context.push(Routes.loginOrSignup.path);

          // Show a snackbar with success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password successfully updated')),
          );
        } else if (state is AuthPasswordRecovery) {
          // Handle other specific states like password recovery if needed
          context.push(Routes.updateForgotPassword.path);
        }
      },
      child: child,
    );
  }
}
