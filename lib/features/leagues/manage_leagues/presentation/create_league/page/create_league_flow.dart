import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/create_league/bloc/cubit/create_league_cubit.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/create_league/widget/forms/create_league_form.dart';

class CreateLeagueFlow extends StatefulWidget {
  const CreateLeagueFlow({super.key});

  @override
  _CreateLeagueFlowState createState() => _CreateLeagueFlowState();
}

class _CreateLeagueFlowState extends State<CreateLeagueFlow> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // context.read<CreateLeagueCubit>().fetchUpcomingGameWeeks();
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
      create: (context) => getIt<CreateLeagueCubit>(),
      child: BlocConsumer<CreateLeagueCubit, CreateLeagueState>(
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            context.push(
              Routes.createLeagueLeagueAfterCompletion.path,
              extra: state.createdLeague,
            );
          } else if (state.status == FormzSubmissionStatus.failure) {
            context.showErrorSnackBarMessage(
              state.errorMessage ??
                  'An error occurred while creating the league.',
            );
          } else {
            _moveToStep(state.createLeagueStep ?? 1);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Create League',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  final currentIndex = context
                          .read<CreateLeagueCubit>()
                          .state
                          .createLeagueStep ??
                      1;
                  if (currentIndex > 1) {
                    context
                        .read<CreateLeagueCubit>()
                        .moveToStep(currentIndex - 1);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.s16),
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8, // Adjusted for the 8th step
                  itemBuilder: (context, index) {
                    return CreateLeagueForm(step: index + 1);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
