import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/auth/presentation/bloc/signup_extra_details/cubit/signup_extra_details_cubit.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/auth/presentation/widget/forms/signup_extra_details_form.dart';

class SignUpExtraDetailsFlow extends StatefulWidget {
  const SignUpExtraDetailsFlow({super.key});

  @override
  _SignUpExtraDetailsFlowState createState() => _SignUpExtraDetailsFlowState();
}

class _SignUpExtraDetailsFlowState extends State<SignUpExtraDetailsFlow> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _moveToStep(int step) {
    _pageController.animateToPage(
      step - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignupExtraDetailsCubit>(),
      child: BlocConsumer<SignupExtraDetailsCubit, SignupExtraDetailsState>(
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            context.go(Routes.home.path);
          } else {
            _moveToStep(state.signUpExtraDetailsStep);
          }
        },
        builder: (context, state) {
          final currentStep = state.signUpExtraDetailsStep;

          return Scaffold(
            appBar: AppBar(
                title: const Text('Complete Your Profile'),
                leading: currentStep > 1
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          context
                              .read<SignupExtraDetailsCubit>()
                              .moveToStep(currentStep - 1);
                        },
                      )
                    : Container()),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PageView.builder(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swiping
                itemCount: 4, // Number of steps
                itemBuilder: (context, index) {
                  return SignUpExtraDetailsForm(step: index + 1);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
