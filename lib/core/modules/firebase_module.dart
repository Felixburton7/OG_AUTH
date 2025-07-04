// lib/core/modules/firebase_module.dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAnalytics get firebaseAnalytics => FirebaseAnalytics.instance;

  @lazySingleton
  FirebaseAnalyticsService get firebaseAnalyticsService =>
      FirebaseAnalyticsService(firebaseAnalytics);
}
