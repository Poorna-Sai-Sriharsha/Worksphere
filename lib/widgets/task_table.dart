import 'package:flutter/material.dart';
import '../models/task.dart';
import '../app/app_theme.dart';

class TaskTable extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onEdit;
  final Function(String) onDelete;

  const TaskTable({
    super.key,
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppTheme.sidebar),
            columnSpacing: 24,
            horizontalMargin: 24,
            columns: const [
              DataColumn(label: Text('TASK', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('STATUS', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('PRIORITY', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('CATEGORY', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
              DataColumn(label: Text('ACTIONS', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
            rows: tasks.map((task) => DataRow(
              cells: [
                DataCell(Text(task.title, style: const TextStyle(color: AppTheme.textPrimary))),
                DataCell(_buildStatusBadge(task.status)),
                DataCell(_buildPriorityBadge(task.priority)),
                DataCell(Text(task.category, style: const TextStyle(color: AppTheme.textSecondary))),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                      onPressed: () => onEdit(task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.danger),
                      onPressed: () => onDelete(task.id),
                    ),
                  ],
                )),
              ],
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TaskStatus status) {
    Color color;
    String text;
    switch (status) {
      case TaskStatus.todo:
        color = AppTheme.textSecondary;
        text = 'Todo';
        break;
      case TaskStatus.inProgress:
        color = AppTheme.primaryAccent;
        text = 'In Progress';
        break;
      case TaskStatus.completed:
        color = AppTheme.success;
        text = 'Completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    Color color;
    String text;
    switch (priority) {
      case TaskPriority.low:
        color = AppTheme.textSecondary;
        text = 'Low';
        break;
      case TaskPriority.medium:
        color = AppTheme.warning;
        text = 'Medium';
        break;
      case TaskPriority.high:
        color = AppTheme.danger;
        text = 'High';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
