import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../app/app_theme.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  const AppTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 800;
    final authProvider = context.watch<AuthProvider>();

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isMobile) ...[
            const Spacer(),
            // Professional Search Bar
            Container(
              width: 300,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1)),
              ),
              child: TextField(
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Search workspace...',
                  hintStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  prefixIcon: Icon(Icons.search, size: 18, color: AppTheme.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          if (isMobile)
            IconButton(
              onPressed: () => authProvider.signOut(),
              icon: const Icon(Icons.logout, color: AppTheme.textSecondary, size: 22),
              tooltip: 'Sign Out',
            )
          else
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.card,
              child: Icon(Icons.notifications_none, size: 18, color: AppTheme.textSecondary),
            ),
        ],
      ),
    );
  }
}
