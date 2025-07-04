// lib/core/services/firebase_analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService(this._analytics);

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> setCurrentScreen(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Sets the current user ID for analytics.
  Future<void> setUserId(String? id) async {
    await _analytics.setUserId(id: id);
  }

  /// Sets a custom property for the user.
  Future<void> setUserProperty(
      {required String name, required String value}) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  /// Enable or disable analytics collection.
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
  }

  /// Resets the analytics data for the current app instance.
  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }
}
