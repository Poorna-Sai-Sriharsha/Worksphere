import 'package:flutter/material.dart';
import 'app_sidebar.dart';
import 'app_top_bar.dart';
import '../app/app_theme.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/tasks/tasks_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String _currentRoute = 'dashboard';

  void _handleRouteChange(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  Widget _buildContent() {
    switch (_currentRoute) {
      case 'dashboard':
        return const DashboardScreen();
      case 'tasks':
        return const TasksScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const Center(child: Text('Not Found'));
    }
  }

  String _getTitle() {
    switch (_currentRoute) {
      case 'dashboard':
        return 'Workspace Dashboard';
      case 'tasks':
        return 'Manage Tasks';
      case 'settings':
        return 'Application Settings';
      default:
        return 'WorkSphere';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Scaffold(
          body: isMobile
              ? Column(
                  children: [
                    AppTopBar(title: _getTitle()),
                    Expanded(
                      child: Container(
                        color: AppTheme.background,
                        child: _buildContent(),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    AppSidebar(
                      selectedRoute: _currentRoute,
                      onRouteChanged: _handleRouteChange,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTopBar(title: _getTitle()),
                          Expanded(
                            child: Container(
                              color: AppTheme.background,
                              child: _buildContent(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: isMobile
              ? BottomNavigationBar(
                  currentIndex: _getSelectedIndex(),
                  onTap: (index) {
                    final routes = ['dashboard', 'tasks', 'settings'];
                    _handleRouteChange(routes[index]);
                  },
                  backgroundColor: AppTheme.sidebar,
                  selectedItemColor: AppTheme.primaryAccent,
                  unselectedItemColor: AppTheme.textSecondary,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
                    BottomNavigationBarItem(icon: Icon(Icons.checklist_outlined), label: 'Tasks'),
                    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
                  ],
                )
              : null,
        );
      },
    );
  }

  int _getSelectedIndex() {
    if (_currentRoute == 'dashboard') return 0;
    if (_currentRoute == 'tasks') return 1;
    if (_currentRoute == 'settings') return 2;
    return 0;
  }
}
