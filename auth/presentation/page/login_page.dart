// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:go_router/go_router.dart';

// import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';
// import 'package:panna_app/features/auth/presentation/widget/forms/login_form.dart';
// import 'package:panna_app/core/extensions/build_context_extensions.dart';
// import 'package:panna_app/core/router/routes.dart';
// import 'package:panna_app/dependency_injection.dart';

// import '../../../../core/constants/spacings.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return _AuthBlocListener(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Log in'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.of(context).pop();
//               // if (Navigator.canPop(context)) {
//               //   Navigator.of(context).pop();
//               // } else {
//               //   context.push(Routes.initial.path);
//               // }
//             },
//           ),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(Spacing.s16),
//             child: BlocProvider(
//               create: (context) => getIt<LoginCubit>(),
//               child: BlocListener<LoginCubit, LoginState>(
//                 listener: (context, state) {
//                   switch (state.status) {
//                     case FormzSubmissionStatus.failure:
//                       context.showErrorSnackBarMessage(
//                         state.errorMessage ??
//                             'Failed to sign in. Please try again.',
//                       );
//                       return;
//                     case FormzSubmissionStatus.success:
//                       if (state.successFromEmail) {
//                         context.showSnackBarMessage(
//                             "User successfully logged in, Welcome!");
//                       } else {
//                         // context.showErrorSnackBarMessage(state.errorMessage ??
//                         //     'Failed to sign in. Please try again.');
//                       }
//                       return;
//                     default:
//                       return;
//                   }
//                 },
//                 child: const LoginForm(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AuthBlocListener extends StatelessWidget {
//   const _AuthBlocListener({
//     required this.child,
//   });

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthBlocState>(
//       listener: (context, state) {
//         if (state is AuthUserAuthenticated) {
//           context.go(Routes.home.path);
//         }
//       },
//       child: child,
//     );
//   }
// }

// // login_page.dart
// // login_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:go_router/go_router.dart';
// import 'package:panna_app/core/constants/spacings.dart';
// import 'package:panna_app/core/extensions/build_context_extensions.dart';
// import 'package:panna_app/core/router/routes.dart';
// import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';
// import 'package:panna_app/dependency_injection.dart';
// import 'package:panna_app/features/auth/presentation/widget/forms/login_form.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return _AuthBlocListener(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Log in'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(Spacing.s16),
//             child: BlocProvider(
//               create: (context) => getIt<LoginCubit>(),
//               child: BlocListener<LoginCubit, LoginState>(
//                 listenWhen: (previous, current) =>
//                     previous.status != current.status,
//                 listener: (context, state) {
//                   // Debugging Statements
//                   print(
//                       'LoginPage: Listener triggered with status ${state.status}');

//                   switch (state.status) {
//                     case FormzSubmissionStatus.failure:
//                       print(
//                           'LoginPage: Showing error snackbar via BlocListener');
//                       context.showErrorSnackBarMessage(
//                         state.errorMessage ??
//                             'Failed to sign in. Please try again.',
//                       );
//                       break;
//                     case FormzSubmissionStatus.success:
//                       if (state.successFromEmail) {
//                         print(
//                             'LoginPage: Showing success snackbar via BlocListener');
//                         context.showSnackBarMessage(
//                           "User successfully logged in, Welcome!",
//                         );
//                       }
//                       break;
//                     default:
//                       break;
//                   }
//                 },
//                 child: const LoginForm(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AuthBlocListener extends StatelessWidget {
//   const _AuthBlocListener({
//     required this.child,
//   });

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthBlocState>(
//       listener: (context, state) async {
//         if (state is AuthUserAuthenticated) {
//           // Delay navigation to allow SnackBar to display
//           await Future.delayed(const Duration(milliseconds: 500));
//           context.go(Routes.home.path);
//         }
//       },
//       child: child,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/services/widgets/screen_tracker.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/auth/presentation/widget/forms/login_form.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTracker(
      screenName: 'LoginPage',
      child: _AuthBlocListener(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Log in'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.s16),
              child: BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: BlocListener<LoginCubit, LoginState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    // Retrieve the analytics service
                    final analyticsService = getIt<FirebaseAnalyticsService>();

                    print(
                        'LoginPage: Listener triggered with status ${state.status}');

                    switch (state.status) {
                      case FormzSubmissionStatus.failure:
                        // Log login failure event
                        analyticsService.logEvent(
                          'login_failure',
                          parameters: {
                            'error': state.errorMessage,
                          },
                        );
                        print(
                            'LoginPage: Showing error snackbar via BlocListener');
                        context.showErrorSnackBarMessage(
                          state.errorMessage ??
                              'Failed to sign in. Please try again.',
                        );
                        break;
                      case FormzSubmissionStatus.success:
                        // Log login success event
                        analyticsService.logEvent(
                          'login_success',
                          parameters: {
                            'method':
                                state.successFromEmail ? 'email' : 'other',
                          },
                        );
                        if (state.successFromEmail) {
                          print(
                              'LoginPage: Showing success snackbar via BlocListener');
                          context.showSnackBarMessage(
                            "User successfully logged in, Welcome!",
                          );
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  child: const LoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthBlocListener extends StatelessWidget {
  const _AuthBlocListener({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) async {
        if (state is AuthUserAuthenticated) {
          // Delay navigation to allow SnackBar to display
          await Future.delayed(const Duration(milliseconds: 500));
          context.go(Routes.home.path);
        }
      },
      child: child,
    );
  }
}
