//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/app/app_theme.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/widgets/transparent_outlined_button.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:panna_app/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:panna_app/features/auth/presentation/widget/login/buttons/login_apple_button.dart';
import 'package:panna_app/dependency_injection.dart';

class LoginOrSignupPage extends StatelessWidget {
  const LoginOrSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the logo path based on the current theme
    final String logoPath = Theme.of(context).brightness == Brightness.light
        ? AppThemeAssets.lightLogo
        : AppThemeAssets.darkLogo;

    return _AuthBlocListener(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 25.0), // Increased padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                SizedBox(
                  height: 210,
                  width: 220,
                  child: Image.asset(logoPath, errorBuilder:
                      (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                    return const Center(
                      child: Text('Could not load image',
                          style: TextStyle(color: Colors.red)),
                    );
                  }),
                ),
                BlocProvider(
                  create: (context) => getIt<LoginCubit>(),
                  child: _LoginButtons(),
                ),
                const Spacer(),
                // const Text(
                //   '18+ verification required for deposits',
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w400,
                //     color: Colors.black54,
                //   ),
                // ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            context.push(Routes.signUp.path);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // More rounded corners
            ),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // const SizedBox(height: 16),
        // Enable Google and Apple buttons as needed
        // const LoginWithGoogleButton(isEnabled: false),
        const SizedBox(height: 16),
        const LoginWithAppleButton(isEnabled: false),
        const SizedBox(height: 16),
        TransparentOutlineButton(
          text: 'Login',
          onPressed: () {
            context.push(Routes.login.path);
          },
          height: 60.0, // Custom height if needed
          borderRadius: 12.0, // Custom border radius if needed
          textStyle: TextStyle(
            fontSize: FontSize.s16,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
          context.go(Routes.home.path);
        }
      },
      child: child,
    );
  }
}
