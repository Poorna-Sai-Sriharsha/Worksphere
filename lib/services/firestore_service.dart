import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection path helper for user isolation
  String _userTasksPath(String uid) => 'users/$uid/tasks';

  // Stream of tasks for a specific user
  Stream<List<Task>> streamTasks(String uid) {
    return _db
        .collection(_userTasksPath(uid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  // Create a new task — uses Firestore auto-generated document ID
  Future<void> addTask(String uid, Task task) async {
    if (task.title.trim().isEmpty) {
      throw Exception('Task title cannot be empty');
    }
    // Use .add() for auto-generated IDs (avoids timestamp collision)
    await _db.collection(_userTasksPath(uid)).add(task.toFirestore());
  }

  // Update an existing task
  Future<void> updateTask(String uid, String taskId, Map<String, dynamic> updates) async {
    if (updates.containsKey('title') && (updates['title'] as String).trim().isEmpty) {
      throw Exception('Task title cannot be empty');
    }
    updates['updatedAt'] = DateTime.now();
    await _db.collection(_userTasksPath(uid)).doc(taskId).update(updates);
  }

  // Delete a task
  Future<void> deleteTask(String uid, String taskId) async {
    await _db.collection(_userTasksPath(uid)).doc(taskId).delete();
  }
}
