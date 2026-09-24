import '../models/task.dart';
import '../services/firestore_service.dart';

class TaskRepository {
  final FirestoreService _firestoreService = FirestoreService();

  // We require UID for every call to enforce isolation
  Stream<List<Task>> getTasks(String uid) {
    return _firestoreService.streamTasks(uid);
  }

  Future<void> createTask(String uid, Task task) async {
    await _firestoreService.addTask(uid, task);
  }

  Future<void> updateTask(String uid, String taskId, Map<String, dynamic> updates) async {
    await _firestoreService.updateTask(uid, taskId, updates);
  }

  Future<void> removeTask(String uid, String taskId) async {
    await _firestoreService.deleteTask(uid, taskId);
  }
}
