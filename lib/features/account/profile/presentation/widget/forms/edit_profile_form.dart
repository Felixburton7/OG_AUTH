import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:panna_app/core/utils/club_picker.dart';
import 'package:panna_app/features/account/profile/presentation/cubit/profile_information_cubit.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';
import 'package:panna_app/features/account/profile/domain/entities/user_profile_entity.dart';

class EditProfileForm extends StatefulWidget {
  final UserProfileEntity profile;
  final ValueChanged<bool> onFormChanged;

  const EditProfileForm({
    Key? key,
    required this.profile,
    required this.onFormChanged,
  }) : super(key: key);

  @override
  EditProfileFormState createState() => EditProfileFormState();
}

class EditProfileFormState extends State<EditProfileForm> {
  late UserProfileEntity profile;

  // Controllers for the fields
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  // FocusNodes for the fields
  Map<String, FocusNode> focusNodes = {};

  // Selected team
  String teamSupported = '';

  @override
  void initState() {
    super.initState();
    profile = widget.profile;

    _firstNameController = TextEditingController(text: profile.firstName);
    _lastNameController = TextEditingController(text: profile.lastName);
    _usernameController = TextEditingController(text: profile.username);
    _bioController = TextEditingController(text: profile.bio ?? '');

    teamSupported = profile.teamSupported ?? '';

    focusNodes = {
      'firstName': FocusNode(),
      'lastName': FocusNode(),
      'username': FocusNode(),
      'bio': FocusNode(),
    };

    // Add listeners to update the form when fields change
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _usernameController.addListener(_onFieldChanged); // New listener added
    _bioController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();

    for (var focusNode in focusNodes.values) {
      focusNode.dispose();
    }

    super.dispose();
  }

  void _onFieldChanged() {
    bool hasChanged = _firstNameController.text != profile.firstName ||
        _lastNameController.text != profile.lastName ||
        _usernameController.text !=
            profile.username || // Check for username changes
        _bioController.text != (profile.bio ?? '') ||
        teamSupported != (profile.teamSupported ?? '');

    widget.onFormChanged(hasChanged);
  }

  void save() {
    // Retrieve the latest avatar URL from the cubit if available.
    final currentState = context.read<ProfileCubit>().state;
    final currentAvatarUrl =
        (currentState is ProfileLoaded || currentState is ProfileAvatarUpdating)
            ? (currentState is ProfileLoaded
                ? currentState.profile.avatarUrl
                : (currentState as ProfileAvatarUpdating).profile.avatarUrl)
            : widget.profile.avatarUrl;

    final updatedProfile = UserProfileDTO(
      profileId: widget.profile.profileId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      teamSupported: teamSupported,
      avatarUrl: currentAvatarUrl,
      accountBalance: widget.profile.accountBalance,
      dateOfBirth: widget.profile.dateOfBirth,
      lmsAverage: widget.profile.lmsAverage,
    );

    context.read<ProfileCubit>().updateProfile(updatedProfile);
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    String fieldKey, {
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isEditable = true,
    String? defaultText,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fieldBackgroundColor = isDarkMode
        ? Theme.of(context).colorScheme.surface.withOpacity(0.8)
        : Colors.grey[200];
    final fieldTextColor = Theme.of(context).textTheme.bodyMedium?.color;
    final hintTextColor = isDarkMode
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
        : Colors.grey[600];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: fieldTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: TextField(
                  controller: controller,
                  focusNode: focusNodes[fieldKey],
                  enabled: isEditable,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fieldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    hintText: defaultText,
                    hintStyle: TextStyle(color: hintTextColor),
                  ),
                  style: TextStyle(fontSize: 16, color: fieldTextColor),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Center(child: _buildEditableAvatar()),
          const SizedBox(height: 10),
          Text(
            'Edit profile picture',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClubPicker(
              selectedTeam: teamSupported,
              onTeamSelected: (selectedTeam) {
                setState(() {
                  teamSupported = selectedTeam;
                  _onFieldChanged();
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          // Username field is now editable with a max length of 15 characters.
          _buildEditableField(
            'Username',
            _usernameController,
            'username',
            maxLength: 15,
          ),
          _buildEditableField(
            'First Name',
            _firstNameController,
            'firstName',
            maxLength: 20,
          ),
          _buildEditableField(
            'Last Name',
            _lastNameController,
            'lastName',
            maxLength: 20,
          ),
          _buildEditableField(
            'Bio',
            _bioController,
            'bio',
            maxLines: 3,
            maxLength: 150,
            defaultText: 'Add a short bio to your profile',
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _buildEditableAvatar() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Retrieve the latest avatar URL from the cubit state
        final avatarUrl =
            (state is ProfileLoaded || state is ProfileAvatarUpdating)
                ? (state is ProfileLoaded
                    ? state.profile.avatarUrl
                    : (state as ProfileAvatarUpdating).profile.avatarUrl)
                : widget.profile.avatarUrl;

        // If there is an avatar URL, append a dummy query parameter to force a refresh.
        final effectiveAvatarUrl = (avatarUrl != null && avatarUrl.isNotEmpty)
            ? '$avatarUrl?t=${DateTime.now().millisecondsSinceEpoch}'
            : null;

        return GestureDetector(
          onTap: () async {
            // Immediately update the profile picture.
            await context.read<ProfileCubit>().selectImage();
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: effectiveAvatarUrl != null
                ? NetworkImage(effectiveAvatarUrl)
                : const AssetImage('assets/images/default_avatar.png')
                    as ImageProvider,
          ),
        );
      },
    );
  }
}
