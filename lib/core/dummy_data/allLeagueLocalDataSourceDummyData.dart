import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/features/leagues/all_leagues/domain/entities/league_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/league_members_entity.dart';
import 'package:panna_app/features/leagues/league_home/domain/entities/selections_entity.dart';

import 'package:panna_app/core/enums/leagues/league_button_action.dart';

@injectable
class AllLeagueLocalDataSourceDummyData {
  static final List<LeagueSummary> dummyLeagueSummaries = [];
}
