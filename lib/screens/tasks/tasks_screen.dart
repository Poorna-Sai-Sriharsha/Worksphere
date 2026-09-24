import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_table.dart';
import '../../widgets/task_dialog.dart';
import '../../app/app_theme.dart';
import '../../models/task.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Workspace Tasks',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Manage and track your professional commitments.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () => _showTaskDialog(context, taskProvider),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Workspace Tasks',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Manage and track your professional commitments.',
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () => _showTaskDialog(context, taskProvider),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 32),
              // Filtering Row
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search tasks...',
                            hintStyle: const TextStyle(color: AppTheme.textSecondary),
                            prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                            filled: true,
                            fillColor: AppTheme.card,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Filter by:', style: TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildFilterChip('All'),
                            _buildFilterChip('High Priority'),
                            _buildFilterChip('Completed'),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search tasks...',
                              hintStyle: const TextStyle(color: AppTheme.textSecondary),
                              prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                              filled: true,
                              fillColor: AppTheme.card,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text('Filter by:', style: TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(width: 8),
                        _buildFilterChip('All'),
                        _buildFilterChip('High Priority'),
                        _buildFilterChip('Completed'),
                      ],
                    ),
              const SizedBox(height: 24),
              // Task Table
              Expanded(
                child: taskProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryAccent))
                    : taskProvider.tasks.isEmpty
                        ? _buildEmptyState()
                        : TaskTable(
                            tasks: taskProvider.tasks,
                            onEdit: (task) => _showTaskDialog(context, taskProvider, task: task),
                            onDelete: (id) => taskProvider.deleteTask(id),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        backgroundColor: AppTheme.card,
        side: const BorderSide(color: AppTheme.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: AppTheme.textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'No tasks found',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Text(
            'Get started by creating your first professional task.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showTaskDialog(BuildContext context, TaskProvider provider, {Task? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(task: task),
    ).then((value) async {
      if (value != null) {
        if (task == null) {
          await provider.addTask(
            value['title'],
            value['description'],
            value['priority'],
            value['category'],
            status: value['status'],
          );
        } else {
          await provider.updateTask(task.id, {
            'title': value['title'],
            'description': value['description'],
            'category': value['category'],
            'status': value['status'],
            'priority': value['priority'],
            'updatedAt': DateTime.now(),
          });
        }
      }
    });
  }
}
