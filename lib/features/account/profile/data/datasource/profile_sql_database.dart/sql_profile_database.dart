import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:panna_app/features/account/profile/data/mapper/user_profile_model.dart';

import 'dart:io';

@injectable
class SQLProfileDataSource {
  static SQLProfileDataSource? _instance; // Singleton instance
  static Database? _database; // Holds the SQLite database instance

  // Private constructor for singleton pattern
  SQLProfileDataSource._createInstance();

  factory SQLProfileDataSource() {
    _instance ??= SQLProfileDataSource._createInstance();
    return _instance!;
  }

  // Initialize the database and store the instance in a field
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  // Initialize the database with path_provider
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'panna_profiles.db');

    // Create the database with the specified schema
    return await openDatabase(
      path,
      version: 1,
      // profile_id TEXT PRIMARY KEY NOT NULL,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE profiles (
          
            updated_at TEXT,
            date_of_birth TEXT,
            username TEXT,
            avatar_url TEXT,
            team_supported TEXT,
            account_balance REAL,
            first_name TEXT,
            last_name TEXT,
            lms_average REAL,
            bio TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertProfile(UserProfileDTO profile) async {
    try {
      final db = await database;

      // Log the profile before insertion

      // Delete all existing profiles
      await db.delete('profiles');

      // Fetch the profiles after deletion to confirm they are gone
      final List<Map<String, Object?>> profilesAfterDeletion =
          await db.query('profiles');

      // Insert the new profile
      await db.insert(
        'profiles',
        profile.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

    } catch (e) {
    }
  }

  Future<UserProfileDTO?> fetchProfile() async {
    try {
      final db = await database;
      // Fetch the profile without needing user_id
      final List<Map<String, Object?>> maps = await db.query('profiles');

      if (maps.isNotEmpty) {
        return UserProfileDTO.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfile(UserProfileDTO profile) async {
    try {
      final db = await database;
      await db.update(
        'profiles',
        profile.toJson(),
        where: 'profile_id = ?',
        whereArgs: [profile.profileId],
      );
    } catch (e) {
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      final db = await database;
      await db.delete(
        'profiles',
        where: 'profile_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
    }
  }
}
