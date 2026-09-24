import 'package:flutter/material.dart';
import '../models/task.dart';
import '../app/app_theme.dart';

class TaskDialog extends StatefulWidget {
  final Task? task; // If null, we are creating. If not null, we are editing.

  const TaskDialog({super.key, this.task});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _catController;
  late TaskStatus _selectedStatus;
  late TaskPriority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _catController = TextEditingController(text: widget.task?.category ?? 'General');
    _selectedStatus = widget.task?.status ?? TaskStatus.todo;
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        widget.task == null ? 'Create Task' : 'Edit Task',
        style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Title'),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: _buildInputDecoration('Enter task title'),
                validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Description'),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: _buildInputDecoration('Enter details...'),
              ),
              const SizedBox(height: 16),
              _buildLabel('Category'),
              TextFormField(
                controller: _catController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: _buildInputDecoration('e.g. Work, Personal'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Status'),
                        DropdownButtonFormField<TaskStatus>(
                          initialValue: _selectedStatus,
                          dropdownColor: AppTheme.card,
                          style: const TextStyle(color: AppTheme.textPrimary),
                          items: TaskStatus.values.map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.name),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedStatus = v!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Priority'),
                        DropdownButtonFormField<TaskPriority>(
                          initialValue: _selectedPriority,
                          dropdownColor: AppTheme.card,
                          style: const TextStyle(color: AppTheme.textPrimary),
                          items: TaskPriority.values.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.name),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedPriority = v!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'title': _titleController.text.trim(),
                'description': _descController.text.trim(),
                'category': _catController.text.trim(),
                'status': _selectedStatus,
                'priority': _selectedPriority,
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: const Text('Save Task'),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textSecondary),
      filled: true,
      fillColor: AppTheme.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppTheme.textSecondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppTheme.primaryAccent, width: 2),
      ),
    );
  }
}
