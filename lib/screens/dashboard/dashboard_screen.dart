import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../app/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../models/task.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    // Calculate stats
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
    final inProgressTasks = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final highPriorityTasks = tasks.where((t) => t.priority == TaskPriority.high).length;
    final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Good morning',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Here's what's happening with your workspace today.",
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Stats Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.5,
                children: [
                  StatCard(
                    title: 'Total Tasks',
                    value: totalTasks.toString(),
                    icon: Icons.assignment_outlined,
                    accentColor: AppTheme.primaryAccent,
                  ),
                  StatCard(
                    title: 'In Progress',
                    value: inProgressTasks.toString(),
                    icon: Icons.sync_outlined,
                    accentColor: AppTheme.warning,
                  ),
                  StatCard(
                    title: 'Completed',
                    value: completedTasks.toString(),
                    icon: Icons.check_circle_outline,
                    accentColor: AppTheme.success,
                  ),
                  StatCard(
                    title: 'High Priority',
                    value: highPriorityTasks.toString(),
                    icon: Icons.warning_amber_rounded,
                    accentColor: AppTheme.danger,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Bottom Section: Focus and Recent
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 800;
              return isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFocusSection(tasks),
                        const SizedBox(height: 20),
                        _buildRecentTasksSection(tasks),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildFocusSection(tasks),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 3,
                          child: _buildRecentTasksSection(tasks),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFocusSection(List<Task> tasks) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Focus",
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${tasks.length - tasks.where((t) => t.status == TaskStatus.completed).length} tasks remaining",
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: tasks.isEmpty ? 0.0 : tasks.where((t) => t.status == TaskStatus.completed).length / tasks.length,
            backgroundColor: AppTheme.background,
            color: AppTheme.primaryAccent,
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          Text(
            "${(tasks.isEmpty ? 0.0 : tasks.where((t) => t.status == TaskStatus.completed).length / tasks.length * 100).toStringAsFixed(1)}% complete",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTasksSection(List<Task> tasks) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.textSecondary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Tasks",
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          tasks.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No recent tasks', style: TextStyle(color: AppTheme.textSecondary)),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length > 5 ? 5 : tasks.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        task.title,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                      ),
                      subtitle: Text(
                        task.category,
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                      trailing: _buildMiniStatus(task.status),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildMiniStatus(TaskStatus status) {
    Color color;
    switch (status) {
      case TaskStatus.completed:
        color = AppTheme.success;
        break;
      case TaskStatus.inProgress:
        color = AppTheme.primaryAccent;
        break;
      case TaskStatus.todo:
        color = AppTheme.textSecondary;
        break;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
