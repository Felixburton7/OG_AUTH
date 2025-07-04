import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/core/utils/club_picker.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/auth/presentation/bloc/signup_extra_details/cubit/signup_extra_details_cubit.dart';
import 'package:panna_app/features/leagues/all_leagues/presentation/bloc/all_leagues/all_leagues_bloc.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class SignUpExtraDetailsForm extends StatefulWidget {
  final int step;

  const SignUpExtraDetailsForm({Key? key, required this.step})
      : super(key: key);

  @override
  _SignUpExtraDetailsFormState createState() => _SignUpExtraDetailsFormState();
}

class _SignUpExtraDetailsFormState extends State<SignUpExtraDetailsForm> {
  @override
  void didUpdateWidget(covariant SignUpExtraDetailsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step != widget.step) {
      // Step has changed, dismiss keyboard and unfocus nodes
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside a TextField
        FocusScope.of(context).unfocus();
      },
      child: BlocBuilder<SignupExtraDetailsCubit, SignupExtraDetailsState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.s8),
              if (widget.step == 1)
                _buildAccountInformationStep(context, state)
              else if (widget.step == 2)
                _buildDateOfBirthStep(context, state)
              else if (widget.step == 3)
                _buildUsernameStep(context, state)
              else if (widget.step == 4)
                _buildProfilePictureStep(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAccountInformationStep(
      BuildContext context, SignupExtraDetailsState state) {
    final cubit = context.read<SignupExtraDetailsCubit>();

    // Validation conditions
    bool isFirstNameValid =
        state.firstName.isNotEmpty && state.firstName.length <= 20;
    bool isSurnameValid =
        state.surname.isNotEmpty && state.surname.length <= 20;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter your first name and surname",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          TextFormField(
            initialValue: state.firstName,
            decoration: InputDecoration(
              labelText: 'First Name',
              fillColor: Theme.of(context).canvasColor,
            ),
            onChanged: (value) => cubit.updateFirstName(value),
          ),
          if (state.firstName.isNotEmpty && state.firstName.length > 20)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'First name cannot exceed 20 characters.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: state.surname,
            decoration: InputDecoration(
              labelText: 'Surname',
              fillColor: Theme.of(context).canvasColor,
            ),
            onChanged: (value) => cubit.updateSurname(value),
          ),
          if (state.surname.isNotEmpty && state.surname.length > 20)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Surname cannot exceed 20 characters.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: isFirstNameValid && isSurnameValid
                  ? () {
                      FocusScope.of(context).unfocus(); // Dismiss the keyboard
                      cubit.moveToStep(2);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Increase border radius
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfBirthStep(
      BuildContext context, SignupExtraDetailsState state) {
    final cubit = context.read<SignupExtraDetailsCubit>();

    // Validation condition
    bool isDateOfBirthValid = state.dateOfBirth != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter your date of birth",
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: Spacing.s16),
        SizedBox(
          height: 250,
          child: ScrollDatePicker(
            selectedDate: state.dateOfBirth ?? DateTime(2000, 1, 1),
            locale: const Locale('en'),
            onDateTimeChanged: (DateTime value) {
              cubit.updateDateOfBirth(value);
            },
          ),
        ),
        const SizedBox(height: Spacing.s16),
        Center(
          child: ElevatedButton(
            onPressed: isDateOfBirthValid
                ? () {
                    FocusScope.of(context).unfocus(); // Dismiss the keyboard
                    cubit.moveToStep(3);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30), // Increase border radius
              ),
            ),
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameStep(
      BuildContext context, SignupExtraDetailsState state) {
    final cubit = context.read<SignupExtraDetailsCubit>();
    final username = state.username;
    final teamSupported = state.teamSupported;

    // Validation conditions
    bool isUsernameValid = username.isNotEmpty && username.length <= 15;
    bool isTeamValid = teamSupported.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose a username",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: username,
            decoration: InputDecoration(
              labelText: 'Username',
              fillColor: Theme.of(context).canvasColor,
            ),
            onChanged: (value) => cubit.updateUsername(value),
          ),
          if (username.isNotEmpty && username.length > 15)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Username cannot exceed 15 characters.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            "Select your team",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          ClubPicker(
            selectedTeam: teamSupported,
            onTeamSelected: (selectedTeam) {
              cubit.updateTeamSupported(selectedTeam);
            },
          ),
          const SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              onPressed: isUsernameValid && isTeamValid
                  ? () {
                      FocusScope.of(context).unfocus(); // Dismiss the keyboard
                      cubit.moveToStep(4);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Increase border radius
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureStep(
      BuildContext context, SignupExtraDetailsState state) {
    final cubit = context.read<SignupExtraDetailsCubit>();

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await cubit.selectImage();
            },
            child: SizedBox(
              width: 150, // Circular size, matching width and height
              height: 150,
              child: (state.avatarUrl != null)
                  ? ClipOval(
                      child: Image.network(
                        state.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Safeguard: If the image fails to load, display a default avatar
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person, // Profile icon
                                size: 50, // Icon size
                                color: Colors.grey, // Icon color
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person, // Profile icon
                          size: 50, // Icon size
                          color: Colors.grey, // Icon color
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: Spacing.s16),
          TextFormField(
            initialValue: state.bio,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'Bio',
              fillColor: Theme.of(context).canvasColor,
            ),
            onChanged: (value) => cubit.updateBio(value),
          ),
          const SizedBox(height: Spacing.s16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
                cubit.submitFinalDetails();
                context.read<ProfileCubit>().fetchProfile();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Increase border radius
                ),
              ),
              child: const Text('Finish'),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
                cubit.submitFinalDetails();
                context.read<ProfileCubit>().fetchProfile();
                context.read<LeagueBloc>().add(FetchUserLeagues());
                context.push(Routes.joinLeague.path);
              },
              child: const Text('Skip for now'),
            ),
          ),
        ],
      ),
    );
  }
}
