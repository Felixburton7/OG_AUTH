// lib/core/widgets/screen_tracker.dart
import 'package:flutter/material.dart';
import 'package:panna_app/dependency_injection.dart';
import 'package:panna_app/core/services/firebase_analytics_service.dart';

class ScreenTracker extends StatefulWidget {
  final String screenName;
  final Widget child;

  const ScreenTracker({
    Key? key,
    required this.screenName,
    required this.child,
  }) : super(key: key);

  @override
  _ScreenTrackerState createState() => _ScreenTrackerState();
}

class _ScreenTrackerState extends State<ScreenTracker> {
  @override
  void initState() {
    super.initState();
    // Log the screen view event after the frame has been rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<FirebaseAnalyticsService>().setCurrentScreen(widget.screenName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
