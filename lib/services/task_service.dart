import 'package:todo_app/models/task.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await saveTasks();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await saveTasks();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index != -1) {
      _tasks[index] = updatedTask;
      await saveTasks();
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index != -1) {
      _tasks[index] = _tasks[index].toggleStatus();
      await saveTasks();
    }
  }

  List<Task> searchTasks(String query) {
    return _tasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(query.toLowerCase()) ||
              task.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  List<Task> filterTask(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  List<Task> priorityTask(int priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  int get totalTasks {
    return _tasks.length;
  }

  int get completedTasks {
    return _tasks.where((task) => task.status == TaskStatus.completed).length;
  }

  int get pendingTasks {
    return _tasks.where((task) => task.status == TaskStatus.pending).length;
  }

  int totalPriorityTasks(int priority) {
    return _tasks.where((task) => task.priority == priority).length;
  }

  List<Task> sortByDate({bool ascending = true}) {
    List<Task> sortedList = _tasks;
    sortedList.sort(
      (a, b) => ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
    return sortedList;
  }

  List<Task> sortByPriority({bool ascending = true}) {
    List<Task> sortedList = _tasks;

    sortedList.sort(
      (a, b) => ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
    return sortedList;
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> encodeTasks = _tasks
        .map((task) => jsonEncode(task.toMap()))
        .toList();

    await prefs.setStringList("tasks", encodeTasks);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? storedTasks = prefs.getStringList("tasks");

    if (storedTasks != null) {
      _tasks.clear();

      for (var task in storedTasks) {
        final Map<String, dynamic> decodedTasks =
            jsonDecode(task) as Map<String, dynamic>;
        _tasks.add(Task.fromMap(decodedTasks));
      }
    }
  }
}
