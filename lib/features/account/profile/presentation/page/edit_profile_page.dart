import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/profile/presentation/widget/forms/edit_profile_form.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfileEntity profile;

  const EditProfilePage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _hasFormChanged = false;
  final GlobalKey<EditProfileFormState> _formKey =
      GlobalKey<EditProfileFormState>();

  @override
  void initState() {
    super.initState();
    getIt<FirebaseAnalyticsService>().setCurrentScreen('EditProfilePage');
  }

  void _onFormChanged(bool hasChanged) {
    setState(() {
      _hasFormChanged = hasChanged;
    });
  }

  void _onSavePressed() {
    _formKey.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            TextButton(
              onPressed: _hasFormChanged ? _onSavePressed : null,
              child: Text(
                'Save',
                style: TextStyle(
                  color: _hasFormChanged ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.s16),
            child: BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdated) {
                  // Show success message:
                  context.showSnackBarMessage("Profile successfully updated.");
                  // Pop back with a 'true' result
                  Navigator.of(context).pop(true);
                } else if (state is ProfileError) {
                  context.showErrorSnackBarMessage(state.message);
                }
              },
              child: EditProfileForm(
                key: _formKey,
                profile: widget.profile,
                onFormChanged: _onFormChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
