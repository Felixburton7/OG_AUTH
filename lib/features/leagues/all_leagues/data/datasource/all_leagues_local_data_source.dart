
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/value_objects/leagues/league_summary.dart';
import 'package:panna_app/core/dummy_data/allLeagueLocalDataSourceDummyData.dart';

@injectable
class AllLeaguesLocalDataSource {
  final AllLeagueLocalDataSourceDummyData allLeagueLocalDataSourceDummyData;
  AllLeaguesLocalDataSource(this.allLeagueLocalDataSourceDummyData);
  // This will eventually use SQFLITE for local storage.
  // For now, it's a placeholder with simple in-memory storage.

  // final List<LeagueSummary> _cachedUserLeagues = []; // Commented out as we will use the dummy data

  // Fetch locally stored user leagues
  Future<List<LeagueSummary>> fetchUserLeagues() async {
    // Simulating data fetch from local storage
    return AllLeagueLocalDataSourceDummyData.dummyLeagueSummaries;
  }

  // Cache leagues locally
  Future<void> uploadLocalAllUserLeagues(
      List<LeagueSummary> leagueSummaries) async {
    // Simulating caching data in local storage
    // _cachedUserLeagues.clear(); // No need to clear the dummy data
    // _cachedUserLeagues.addAll(leagueSummaries);
  }
}

// class AllLeaguesLocalDataSource {
//   static AllLeaguesLocalDataSource? _instance;
//   static Database? _database;

//   AllLeaguesLocalDataSource._createInstance();

//   factory AllLeaguesLocalDataSource() {
//     if (_instance == null) {
//       _instance = AllLeaguesLocalDataSource._createInstance();
//     }
//     return _instance!;
//   }

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await _initializeDatabase();
//     return _database!;
//   }

//   Future<Database> _initializeDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, 'leagues.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//        CREATE TABLE leagues (
//     league_id TEXT PRIMARY KEY,
//     league_name TEXT,
//     is_user_a_member INTEGER,
//     number_of_weeks_active INTEGER,
//     next_round_start_date TEXT,
//     current_round_status INTEGER,
//     member_count INTEGER,
//     mutual_member_count INTEGER,
//     total_pot REAL,
//     upcoming_selection TEXT,
//     current_round INTEGER,
//     button_action TEXT,
//     created_by TEXT,
//     buy_in REAL,
//     created_at TEXT,
//     add_code TEXT,
//     league_avatar_url TEXT,
//     league_is_private INTEGER,
//     first_survivor_round_start_date TEXT,
//     league_bio TEXT,
//     selection_id TEXT,
//     user_id TEXT,
//     username TEXT,
//     round_id TEXT,
//     team_id TEXT,
//     team_name TEXT,
//     game_week_id TEXT,
//     game_week_number INTEGER,
//     selection_date TEXT,
//     made_selection_status INTEGER,
//     result INTEGER,
//     survivor_status INTEGER,
//     paid_buy_in INTEGER,
//     admin INTEGER,
//     first_name TEXT,
//     last_name TEXT,
//     avatar_url TEXT,
//     team_supported TEXT,
//     account_balance REAL,
//     lms_average REAL,
//     bio TEXT,
//     date_of_birth TEXT

//         ''');
//       },
//     );
//   }

//   Future<void> insertLeagues(List<LeagueSummary> leagues) async {
//     final db = await database;

//     await db.delete('leagues'); // Clear existing data
//     for (var league in leagues) {
//       await db.insert(
//         'leagues',
//         league.toJson(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }
//   }

//   Future<List<LeagueSummary>> fetchUserLeagues() async {
//     final db = await database;
//     final result = await db.query('leagues');
//     return result.map((json) => LeagueSummary.fromJson(json)).toList();
//   }

//   Future<void> uploadLocalAllUserLeagues(List<LeagueSummary> leagues) async {
//     await insertLeagues(leagues);
//   }
// }

