import 'package:intl/intl.dart';
import 'package:panna_app/features/fixtures_and_standings/domain/entities/fixture_entity.dart';

class GetGameweekDeadlineFromUpcomingFixtures {
  /// Retrieves the Gameweek Deadline from the list of upcoming fixtures.
  ///
  /// [upcomingFixtures] - A list of FixtureEntity objects representing upcoming matches.
  ///
  /// Returns a formatted date and time string (e.g., "19 Oct 2024 10:30 AM") or 'N/A' if not available.
  String getDeadline(List<FixtureEntity> upcomingFixtures) {
    if (upcomingFixtures.isEmpty) {
      return 'N/A';
    }

    try {
      // Define a far-future date to represent the maximum possible date
      final DateTime farFuture = DateTime(9999, 12, 31);

      // Sort fixtures by startTime to ensure the first fixture is the earliest
      upcomingFixtures.sort((a, b) {
        DateTime aTime = a.startTime ?? farFuture;
        DateTime bTime = b.startTime ?? farFuture;
        return aTime.compareTo(bTime);
      });

      // Get the first fixture with a non-null startTime
      final firstFixture = upcomingFixtures.firstWhere(
        (fixture) => fixture.startTime != null,
        orElse: () => upcomingFixtures.first,
      );

      final deadlineDate = firstFixture.startTime;

      if (deadlineDate == null) {
        return 'N/A';
      }

      // Format the date and time as 'd MMM yyyy h:mm a' (e.g., '19 Oct 2024 10:30 AM')
      return DateFormat('d MMMM h:mm a').format(deadlineDate.toLocal());
    } catch (e) {
      // In case of any parsing or formatting errors
      return 'N/A';
    }
  }
}
