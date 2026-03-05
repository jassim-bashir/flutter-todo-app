import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import 'task_service.dart';

final taskNotifierProvider =
    AsyncNotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late final TaskService _service;

  @override
  Future<List<Task>> build() async {
    _service = TaskService();
    await _service.init(); // wait for file to load
    return _service.tasks;
  }

  Future<void> addTask(Task task) async {
    await _service.addTask(task);
    state = AsyncData(List<Task>.from(_service.tasks));
  }

  Future<void> toggleTaskStatus(String id) async {
    await _service.toggleTaskStatus(id);
    state = AsyncData(List<Task>.from(_service.tasks));
  }

  Future<void> deleteTask(String id) async {
    await _service.deleteTask(id);
    state = AsyncData(List<Task>.from(_service.tasks));
  }
}
