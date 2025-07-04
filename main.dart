import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:panna_app/core/extensions/hive_extensions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:panna_app/core/secrets/secrets.dart';
import 'package:panna_app/core/services/fcm_service.dart';
import 'package:panna_app/features/account/profile/data/datasource/profile_sql_database.dart/sql_profile_database.dart';
import 'package:panna_app/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:panna_app/core/app/app.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

// PANNA APP main.dart entry point:
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_GB', null); // Initialise 'en_GB' locale
  await _initializeFirebase(); // Initialise Firebase

  await _initializeSupabase();
  await _initializeSQLite(); // Initialise SQLite

  await _initializeHive();
  configureDependencyInjection(); // after 
  _initalizeFCM();

  runApp(const PannaApp());
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create an instance of FirebaseAnalytics
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Create an instance of your analytics service
  final FirebaseAnalyticsService analyticsService =
      FirebaseAnalyticsService(analytics);

  // Log a custom "app_open" event using your service
  await analyticsService.logEvent('app_open', parameters: {
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Optionally, register the analytics service with your dependency injection container:
}

Future<void> _initalizeFCM() async {
  /// Now init FCM
  await FCMService.initFCM(
    onNewToken: (fcmToken) async {
      print('FCM init is running');
      // E.g. store token in Supabase, if user is logged in:
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      print('Supabase user $user');
      if (user != null) {
        // Upsert into your 'profiles.fcm_token'
        final response = await supabase
            .from('profiles')
            .update({'fcm_token': fcmToken}).eq('profile_id', user.id);
        if (response.error != null) {
          debugPrint('Error saving FCM token: ${response.error!.message}');
        } else {
          debugPrint('FCM token saved to Supabase for user ${user.id}');
        }
      }
    },
  );
}

Future<void> _initializeSupabase() async {
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
}

Future<void> _initializeHive() async {
  await Hive.initFlutter();
  await Hive.openThemeModeBox();
}

// Simple SQLite initialisation method
Future<void> _initializeSQLite() async {
  final db = await SQLProfileDataSource()
      .database; // Open the SQLite database for profiles
}


// CALLING THIS ERROR LOGIC, and for tracking, much better. 
// await runZonedGuarded(
//       () async {
//         await setup();
//       },
//       (error, detail) {
//         FirebaseCrashlytics.instance.recordError(error, detail, printDetails: true, reason: 'Before app start crash');
//         _listenErrorFromTalker(error, detail);
//       },
//     );
// FlutterError.onError = (errorDetails) {
//       printError(errorDetails.exceptionAsString());
//       _listenErrorFromTalker(errorDetails.exceptionAsString(), errorDetails.stack);

//       FirebaseCrashlytics.instance.recordFlutterError(errorDetails,
//           fatal: !(errorDetails.exception is HttpException ||
//               errorDetails.exception is SocketException ||
//               errorDetails.exception is HandshakeException ||
//               errorDetails.exception is ClientException));
//     };


#!/bin/bash

cd ios/

# Remove all build related directories
echo "🗑️ Removing build directories..."
rm -rf build/
rm -rf Pods/
rm -rf .symlinks/
rm -rf Flutter/Flutter.framework/
rm -rf Flutter/Flutter.podspec
rm -rf Flutter/Generated.xcconfig
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies
rm -rf Podfile.lock

# Remove XCode derived data
echo "🗑️ Removing Xcode DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Remove XCode cache
echo "🗑️ Removing Xcode cache..."