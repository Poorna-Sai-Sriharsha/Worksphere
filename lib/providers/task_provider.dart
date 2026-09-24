import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription? _taskSubscription;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateUser(User? user) {
    _taskSubscription?.cancel();
    _taskSubscription = null;

    if (_tasks.isNotEmpty) {
      _tasks = [];
      notifyListeners();
    }

    if (user != null) {
      _taskSubscription = _repository.getTasks(user.uid).listen(
        (updatedTasks) {
          _tasks = updatedTasks;
          notifyListeners();
        },
        onError: (e) {
          _errorMessage = e.toString();
          notifyListeners();
        },
      );
    }
  }

  Future<void> addTask(
    String title,
    String description,
    TaskPriority priority,
    String category, {
    TaskStatus status = TaskStatus.todo,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _setLoading(true);
    try {
      final newTask = Task(
        id: '', // Will be replaced by Firestore auto-ID
        title: title,
        description: description,
        status: status,
        priority: priority,
        category: category,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.createTask(user.uid, newTask);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updates) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _repository.updateTask(user.uid, taskId, updates);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _repository.removeTask(user.uid, taskId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }
}
