import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../app/app_theme.dart';

class AppSidebar extends StatelessWidget {
  final String selectedRoute;
  final Function(String) onRouteChanged;

  const AppSidebar({
    super.key,
    required this.selectedRoute,
    required this.onRouteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Container(
      width: 260,
      color: AppTheme.sidebar,
      child: Column(
        children: [
          // Logo Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.grid_view_rounded, color: AppTheme.primaryAccent, size: 28),
                SizedBox(width: 12),
                Text(
                  'WORKSPHERE',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, indent: 24, endIndent: 24),
          const SizedBox(height: 16),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildNavItem('Dashboard', Icons.dashboard_outlined, 'dashboard'),
                _buildNavItem('Tasks', Icons.checklist_outlined, 'tasks'),
                _buildNavItem('Settings', Icons.settings_outlined, 'settings'),
              ],
            ),
          ),

          // User Profile Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primaryAccent,
                      child: Text(
                        authProvider.user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        authProvider.user?.email ?? 'User',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: TextButton.icon(
                    onPressed: () => authProvider.signOut(),
                    icon: const Icon(Icons.logout, size: 18, color: AppTheme.textSecondary),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, String route) {
    final isSelected = selectedRoute == route;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onRouteChanged(route),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.card : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
              ? const Border(left: BorderSide(color: AppTheme.primaryAccent, width: 4))
              : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryAccent : AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
