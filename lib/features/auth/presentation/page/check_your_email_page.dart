import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/auth/presentation/bloc/auth_bloc.dart';

class CheckYourEmailPage extends StatelessWidget {
  const CheckYourEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme for primary color
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Your Email'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<AuthBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthPasswordRecovery) {
            // Navigate to the UpdateForgotPasswordPage when the password recovery state is detected
            context.push(Routes.updateForgotPassword.path);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "We've sent a password reset link to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // Make text smaller
                  letterSpacing: 0.5, // Slightly spaced out letters
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Please check your inbox and follow the instructions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.primaryColorDark,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Please stay on this page to proceed. The email should arrive within 1 minute, but it may take up to 5 minutes.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Optionally go back to the login/signup screen
                  context.push(Routes.loginOrSignup.path);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Rounded corners for button
                  ),
                ),
                child: const Text("Cancel Request and Go Back to Login"),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "If you encounter any issues, please email info@panna.app.uk.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.primaryColor
                        .withOpacity(0.7), // Lighter primary color
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
