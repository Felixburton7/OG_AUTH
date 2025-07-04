import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:panna_app/core/constants/colors.dart';
import 'package:panna_app/core/constants/font_sizes.dart';
import 'package:panna_app/core/constants/spacings.dart';
import 'package:panna_app/features/leagues/manage_leagues/presentation/create_league/bloc/cubit/create_league_cubit.dart';

class CreateLeagueForm extends StatefulWidget {
  final int step;

  const CreateLeagueForm({Key? key, required this.step}) : super(key: key);

  @override
  _CreateLeagueFormState createState() => _CreateLeagueFormState();
}

class _CreateLeagueFormState extends State<CreateLeagueForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController buyInController = TextEditingController();
  final TextEditingController maxPlayersController = TextEditingController();
  final TextEditingController leagueBioController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final state = context.read<CreateLeagueCubit>().state;

    // Initialize controllers with existing state values
    titleController.text = state.leagueTitle ?? '';
    buyInController.text = state.buyIn != null ? state.buyIn.toString() : '0.0';
    maxPlayersController.text =
        state.maxPlayers != null ? state.maxPlayers.toString() : '';
    leagueBioController.text = state.leagueBio ?? '';

    // Add listeners to update the state when the text changes
    titleController.addListener(() {
      context.read<CreateLeagueCubit>().updateLeagueTitle(titleController.text);
    });

    buyInController.addListener(() {
      final amount = double.tryParse(buyInController.text) ?? 0.0;
      context.read<CreateLeagueCubit>().updateBuyIn(amount);
    });

    maxPlayersController.addListener(() {
      final maxPlayers = int.tryParse(maxPlayersController.text);
      if (maxPlayers != null) {
        context.read<CreateLeagueCubit>().updateMaxPlayers(maxPlayers);
      }
    });

    leagueBioController.addListener(() {
      context
          .read<CreateLeagueCubit>()
          .updateLeagueBio(leagueBioController.text);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    buyInController.dispose();
    maxPlayersController.dispose();
    leagueBioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocBuilder<CreateLeagueCubit, CreateLeagueState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.s8),
              if (widget.step == 1)
                _buildLeagueTypeStep(context)
              else if (widget.step == 2)
                _buildLeagueGameStep(context)
              else if (widget.step == 3)
                _buildLeagueTitleStep(context, state)
              else if (widget.step == 4)
                _buildBuyInStep(context, state)
              else if (widget.step == 5)
                _buildSurvivorRoundStartDateStep(context, state)
              else if (widget.step == 6)
                _buildMaxPlayersStep(context, state)
              else if (widget.step == 7)
                _buildLeagueAvatarStep(context, state)
              else if (widget.step == 8)
                _buildReviewStep(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeagueTypeStep(BuildContext context) {
    // ... (no changes needed here)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Game Type", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Spacing.s16),
        GestureDetector(
          onTap: () => context.read<CreateLeagueCubit>().moveToStep(2),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.grey300, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Last Man Standing\n', // Regular text with a line break
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: '(Default)', // Text below in a different style
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              // color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12, // Smaller font size
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.man_2_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeagueGameStep(BuildContext context) {
    // ... (no changes needed here)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Choose League and Game",
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Spacing.s16),
        GestureDetector(
          onTap: () => context.read<CreateLeagueCubit>().moveToStep(3),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.grey300, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'English Premier League\n', // Regular text with a line break
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: '(Default)', // Text below in a different style
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              // color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12, // Smaller font size
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.sports_soccer,
                    color: Theme.of(context).primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeagueTitleStep(BuildContext context, CreateLeagueState state) {
    bool isTitleValid = state.leagueTitle != null &&
        state.leagueTitle!.length >= 4 &&
        state.leagueTitle!.length <= 15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter League Title",
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Spacing.s16),
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
              labelText: 'League Title',
              fillColor: Theme.of(context).canvasColor),
        ),
        if (!isTitleValid)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '  League title must be between 5 and 15 characters long.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: Spacing.s16),
        SwitchListTile(
          title: Text(
            state.leagueIsPrivate ?? true ? 'Private League' : 'Public League',
          ),
          value: state.leagueIsPrivate ?? true,
          onChanged: (value) =>
              context.read<CreateLeagueCubit>().updateLeagueIsPrivate(value),
        ),
        const SizedBox(height: Spacing.s16),
        ElevatedButton(
          onPressed: isTitleValid
              ? () {
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                  context.read<CreateLeagueCubit>().moveToStep(4);
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              isTitleValid
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildBuyInStep(BuildContext context, CreateLeagueState state) {
    bool isBuyInValid = state.buyIn != null && state.buyIn! <= 500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Set Buy-In Amount",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Spacing.s16),
        TextFormField(
          controller: buyInController,
          decoration: InputDecoration(
              labelText: 'Buy-In Amount',
              fillColor: Theme.of(context).canvasColor),
          keyboardType: TextInputType.number,
        ),
        if (!isBuyInValid)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Buy-in amount cannot exceed £500.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: Spacing.s16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBuyInOption(context, '£5', 5.0),
            _buildBuyInOption(context, '£10', 10.0),
            _buildBuyInOption(context, '£50', 50.0),
          ],
        ),
        const SizedBox(height: Spacing.s16),
        _buildBuyInOption(context, 'No Buy-In', 0.0,
            fullWidth: true, isReset: true),
        const SizedBox(height: Spacing.s16),
        ElevatedButton(
          onPressed: isBuyInValid
              ? () {
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                  context.read<CreateLeagueCubit>().moveToStep(5);
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              isBuyInValid
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildBuyInOption(BuildContext context, String label, double amount,
      {bool fullWidth = false, bool isReset = false}) {
    // Determine if this option is selected
    double currentAmount = double.tryParse(buyInController.text) ?? 0.0;
    bool isSelected = (isReset && currentAmount == 0.0) ||
        (!isReset && currentAmount == amount);

    return GestureDetector(
      onTap: () {
        double newAmount = isReset ? 0.0 : amount;

        if (newAmount <= 500) {
          buyInController.text = newAmount.toString();
          context.read<CreateLeagueCubit>().updateBuyIn(newAmount);
        }
      },
      child: Container(
        width: fullWidth ? double.infinity : 120, // Set a wider width
        padding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 24.0), // Increased padding
        margin:
            const EdgeInsets.only(bottom: 8.0), // Adds space between buttons
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.white, // Highlight selected option
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.grey300, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Change text color based on selection
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurvivorRoundStartDateStep(
      BuildContext context, CreateLeagueState state) {
    final gameWeeks = state.upcomingGameWeeks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Choose Survivor Round Start Date",
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Spacing.s16),
        if (gameWeeks == null)
          CircularProgressIndicator() // Loading state
        else if (gameWeeks.isEmpty)
          Text("No upcoming game week available") // No data state
        else
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
                labelText: 'Start Date',
                fillColor: Theme.of(context).canvasColor),
            value: state.firstSurvivorRoundStartDate, // Retain selected value
            items: gameWeeks.map<DropdownMenuItem<String>>((week) {
              final String id = week['id'] ?? '';
              final String label = week['label'] ?? '';
              return DropdownMenuItem<String>(
                value: id,
                child: Text(label),
              );
            }).toList(),
            onChanged: (selectedId) {
              if (selectedId != null) {
                context
                    .read<CreateLeagueCubit>()
                    .updateFirstSurvivorRoundStartDate(selectedId);
              }
            },
          ),
        const SizedBox(height: Spacing.s16),
        ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus(); // Dismiss the keyboard
            context.read<CreateLeagueCubit>().moveToStep(6);
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildMaxPlayersStep(BuildContext context, CreateLeagueState state) {
    bool isMaxPlayersValid = state.maxPlayers != null &&
        state.maxPlayers! >= 2 &&
        state.maxPlayers! <= 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Maximum Number of Players",
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: Spacing.s16),
        TextFormField(
          controller: maxPlayersController,
          decoration: InputDecoration(
              labelText: 'Maximum Players',
              fillColor: Theme.of(context).canvasColor),
          keyboardType: TextInputType.number,
        ),
        if (!isMaxPlayersValid)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Maximum players must be between 2 and 100.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(height: Spacing.s16),
        TextFormField(
          controller: leagueBioController,
          decoration: InputDecoration(
              labelText: 'League Bio',
              alignLabelWithHint: true,
              fillColor: Theme.of(context).canvasColor),
          maxLines: 2,
        ),
        const SizedBox(height: Spacing.s16),
        ElevatedButton(
          onPressed: isMaxPlayersValid
              ? () {
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                  context.read<CreateLeagueCubit>().moveToStep(7);
                }
              : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              isMaxPlayersValid
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildLeagueAvatarStep(BuildContext context, CreateLeagueState state) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Select League Picture",
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              await context.read<CreateLeagueCubit>().selectImage();
            },
            child: SizedBox(
              width: 200,
              height: 200,
              child: state.image != null
                  ? ClipOval(
                      child: Image.file(state.image!, fit: BoxFit.cover),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: const Center(
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: Spacing.s16),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus(); // Dismiss the keyboard
              context.read<CreateLeagueCubit>().moveToStep(8);
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(BuildContext context, CreateLeagueState state) {
    // Find the label corresponding to the selected `firstSurvivorRoundStartDate`
    String startWeekLabel = "N/A";
    if (state.firstSurvivorRoundStartDate != null) {
      final selectedGameWeek = state.upcomingGameWeeks?.firstWhere(
        (week) => week['id'] == state.firstSurvivorRoundStartDate,
        orElse: () => {},
      );
      startWeekLabel = selectedGameWeek?['label'] ?? "N/A";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Review Your League Details",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.s16),
          _buildReviewItem(
              Icons.edit, "TITLE", state.leagueTitle ?? "N/A", context),
          const SizedBox(height: Spacing.s8),
          _buildReviewItem(
              Icons.shield, "GAME TYPE", "Last Man Standing", context),
          const SizedBox(height: Spacing.s8),
          _buildReviewItem(
              Icons.leaderboard, "LEAGUE", "Premier League", context),
          const SizedBox(height: Spacing.s8),
          _buildReviewItem(
              Icons.money, "BUY-IN", "£${state.buyIn ?? 0.0}", context),
          const SizedBox(height: Spacing.s8),
          _buildReviewItem(
              Icons.people, "MAX PLAYERS", "${state.maxPlayers ?? 2}", context),
          const SizedBox(height: Spacing.s8),
          _buildReviewItem(Icons.calendar_today, "START WEEK", startWeekLabel,
              context), // Updated to show the label
          const SizedBox(height: Spacing.s16),
          ElevatedButton(
            onPressed: state.status == FormzSubmissionStatus.inProgress
                ? null
                : () async {
                    await context.read<CreateLeagueCubit>().submitLeague();
                  },
            child: const Text('Create League'),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
      IconData icon, String title, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey), // Icon on the left
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(), // Capitalizing the title
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.grey800),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
