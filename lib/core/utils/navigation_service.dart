import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static String _currentRoute = 'dashboard';
  static String get currentRoute => _currentRoute;

  static void setRoute(String route) {
    _currentRoute = route;
  }

  static void navigateToDashboard() {
    _currentRoute = 'dashboard';
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/dashboard', (route) => false);
  }

  static void navigateToLogin() {
    _currentRoute = 'login';
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
