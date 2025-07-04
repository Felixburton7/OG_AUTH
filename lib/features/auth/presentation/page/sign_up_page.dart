// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:go_router/go_router.dart';
// import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart';
// import 'package:panna_app/features/auth/presentation/widget/forms/signup_form.dart';
// import 'package:panna_app/core/extensions/build_context_extensions.dart';
// import 'package:panna_app/core/router/routes.dart';
// import 'package:panna_app/dependency_injection.dart';
// import '../../../../core/constants/spacings.dart';

// class SignUpPage extends StatelessWidget {
//   const SignUpPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _AuthBlocListener(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Create account'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               if (Navigator.canPop(context)) {
//                 Navigator.of(context).pop();
//               } else {
//                 context.push(Routes.initial.path);
//               }
//             },
//           ),
//         ),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(Spacing.s16),
//             child: BlocProvider(
//               create: (context) => getIt<SignUpCubit>(),
//               child: BlocListener<SignUpCubit, SignUpState>(
//                 listener: (context, state) {
//                   switch (state.status) {
//                     case FormzSubmissionStatus.failure:
//                       context.showErrorSnackBarMessage(
//                         state.errorMessage ??
//                             'Sorry, the email and password were invalid',
//                       );
//                       break;
//                     case FormzSubmissionStatus.success:
//                       context.showSnackBarMessage(
//                         'Please confirm your email',
//                       );
//                       break;
//                     default:
//                       return;
//                   }
//                 },
//                 child: const SignUpForm(),
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
//           context.push(Routes.signupExtraDetails.path);
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
import 'package:panna_app/core/services/widgets/screen_tracker.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:panna_app/features/auth/presentation/bloc/signup/signup_cubit.dart';
import 'package:panna_app/features/auth/presentation/widget/forms/signup_form.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTracker(
      screenName: 'SignUpPage',
      child: _AuthBlocListener(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create account'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                } else {
                  context.push(Routes.initial.path);
                }
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.s16),
              child: BlocProvider(
                create: (context) => getIt<SignUpCubit>(),
                child: BlocListener<SignUpCubit, SignUpState>(
                  listener: (context, state) {
                    // Retrieve the analytics service
                    final analyticsService = getIt<FirebaseAnalyticsService>();

                    switch (state.status) {
                      case FormzSubmissionStatus.failure:
                        analyticsService.logEvent(
                          'signup_failure',
                          parameters: {
                            'error': state.errorMessage,
                          },
                        );
                        context.showErrorSnackBarMessage(
                          state.errorMessage ??
                              'Sorry, the email and password were invalid',
                        );
                        break;
                      case FormzSubmissionStatus.success:
                        analyticsService.logEvent(
                          'signup_success',
                        );
                        context.showSnackBarMessage(
                          'Please confirm your email',
                        );
                        break;
                      default:
                        return;
                    }
                  },
                  child: const SignUpForm(),
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
      listener: (context, state) {
        if (state is AuthUserAuthenticated) {
          context.push(Routes.signupExtraDetails.path);
        }
      },
      child: child,
    );
  }
}
