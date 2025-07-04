import 'dart:io';

import 'package:flutter/material.dart';
import 'package:panna_app/core/utils/pick_image.dart';
import 'package:panna_app/core/value_objects/leagues/league_details.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/features/leagues/all_leagues/data/mapper/all_leaguesDTO.dart';
import 'package:panna_app/features/leagues/manage_leagues/domain/repository/manage_leagues_repository.dart';

class LeagueAdminPanel extends StatefulWidget {
  final LeagueDetails leagueDetails;

  const LeagueAdminPanel({
    Key? key,
    required this.leagueDetails,
  }) : super(key: key);

  @override
  State<LeagueAdminPanel> createState() => _LeagueAdminPanelState();
}

class _LeagueAdminPanelState extends State<LeagueAdminPanel> {
  late String leagueTitle;
  late String leagueBio;
  late double buyIn;
  late String avatarUrl;
  File? _selectedImage;

  final _formKey = GlobalKey<FormState>();

  // Initialize services via dependency injection
  final ImageUploadService _imageUploadService = getIt<ImageUploadService>();
  final ManageLeaguesRepository _manageLeaguesRepository =
      getIt<ManageLeaguesRepository>();

  @override
  void initState() {
    super.initState();
    // Initialize with real data from leagueDetails
    leagueTitle = widget.leagueDetails.league.leagueTitle ?? '';
    leagueBio = widget.leagueDetails.league.leagueBio ?? '';
    buyIn = widget.leagueDetails.league.buyIn ?? 0.0;
    avatarUrl = widget.leagueDetails.league.leagueAvatarUrl ??
        'https://via.placeholder.com/150';
  }

  Future<void> _selectImage() async {
    try {
      final pickedImage = await _imageUploadService.pickImage();
      if (pickedImage != null) {
        setState(() {
          _selectedImage = pickedImage;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image: $error')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      String? newAvatarUrl = avatarUrl;

      // If a new image is selected, upload it
      if (_selectedImage != null) {
        newAvatarUrl = await _imageUploadService.uploadImageLeague(
          _selectedImage!,
          widget.leagueDetails.league.leagueId!,
        );
      }

      // Create an updated league DTO
      final updatedLeagueDTO = LeagueDTO(
        leagueId: widget.leagueDetails.league.leagueId,
        leagueTitle: leagueTitle,
        leagueBio: leagueBio,
        buyIn: buyIn,
        leagueAvatarUrl: newAvatarUrl,
        // Add other necessary fields
      );

      // Update league details in the backend
      await _manageLeaguesRepository.updateLeagueDetails(updatedLeagueDTO);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('League details updated successfully')),
      );

      // Pop and return true to indicate that changes were made
      Navigator.pop(context, true);
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating league details: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false or null when navigating back without saving
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("League Admin Panel"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Change League Avatar
                  Center(
                    child: _buildAdminItem(
                      title: "Change League Avatar",
                      child: GestureDetector(
                        onTap: _selectImage,
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : NetworkImage(avatarUrl) as ImageProvider,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black38,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Change League Title
                  _buildAdminItem(
                    title: "Change League Title",
                    child: TextFormField(
                      initialValue: leagueTitle,
                      decoration: const InputDecoration(
                        labelText: 'League Title',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 12,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'League title is required';
                        }
                        if (value.trim().length < 3 ||
                            value.trim().length > 12) {
                          return 'League title must be between 3 and 12 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        leagueTitle = value!.trim();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Change Next Round's Buy-In
                  _buildAdminItem(
                    title: "Change Next Round's Buy-In",
                    child: TextFormField(
                      initialValue: buyIn.toString(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Buy-In Amount (£)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Buy-In amount is required';
                        }
                        final buyInValue = double.tryParse(value);
                        if (buyInValue == null || buyInValue < 0) {
                          return 'Please enter a valid amount';
                        }
                        if (buyInValue > 500) {
                          return 'Buy-In amount cannot exceed £500';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        buyIn = double.tryParse(value!) ?? buyIn;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Change League Bio
                  _buildAdminItem(
                    title: "Change League Bio",
                    child: TextFormField(
                      initialValue: leagueBio,
                      decoration: const InputDecoration(
                        labelText: 'League Bio',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      maxLength: 200,
                      onSaved: (value) {
                        leagueBio = value!.trim();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save Changes Button
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each section
  Widget _buildAdminItem({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
