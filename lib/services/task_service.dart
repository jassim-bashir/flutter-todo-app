/// Task Service
/// Handles CRUD, search, filter, sort, statistics
/// Also handles persistence to local JSON file

import '../models/task.dart';
import 'dart:io';
import 'dart:convert';

class TaskService {
  final List<Task> _tasks = [];

  // =========================
  // FILE PERSISTENCE
  // =========================

  /// Path to store tasks JSON file
  /// (For milestone purposes, saved in project root)
  final String _filePath = 'tasks.json';

  // =========================
  // GETTERS
  // =========================
  List<Task> get tasks => List.unmodifiable(_tasks);

  // =========================
  // CRUD METHODS
  // =========================

  /// Add a task and save to file
  Future<void> addTask(Task task) async {
    _validateTask(task);
    _tasks.add(task);
    await saveToFile(); // Persistence: Save after mutation
  }

  /// Delete a task by ID and save to file
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await saveToFile(); // Persistence: Save after mutation
  }

  /// Update task and save to file
  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index == -1) {
      throw Exception('Task not found');
    }

    _validateTask(updatedTask);
    _tasks[index] = updatedTask;

    await saveToFile(); // Persistence: Save after mutation
  }

  /// Toggle task status and save to file
  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      throw Exception('Task not found');
    }

    _tasks[index] = _tasks[index].toggleStatus();

    await saveToFile(); // Persistence: Save after mutation
  }

  // =========================
  // SEARCH
  // =========================

  List<Task> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
          task.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // =========================
  // FILTERING
  // =========================

  List<Task> filterByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  List<Task> filterByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  // =========================
  // SORTING
  // =========================

  List<Task> sortByDate({bool ascending = true}) {
    final sorted = List<Task>.from(_tasks);

    sorted.sort(
      (a, b) => ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );

    return sorted;
  }

  List<Task> sortByPriority({bool highFirst = true}) {
    final sorted = List<Task>.from(_tasks);

    sorted.sort(
      (a, b) => highFirst
          ? b.priority.index.compareTo(a.priority.index)
          : a.priority.index.compareTo(b.priority.index),
    );

    return sorted;
  }

  List<Task> sortByStatus() {
    final sorted = List<Task>.from(_tasks);

    sorted.sort((a, b) => a.status.index.compareTo(b.status.index));

    return sorted;
  }

  // =========================
  // STATISTICS
  // =========================

  int get totalTasks => _tasks.length;

  int get completedTasks =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;

  int get pendingTasks =>
      _tasks.where((t) => t.status == TaskStatus.pending).length;

  int countByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).length;
  }

  // =========================
  // PERSISTENCE METHODS
  // =========================

  /// Save tasks to local JSON file
  Future<void> saveToFile() async {
    final file = File(_filePath);
    final taskMaps = _tasks.map((task) => task.toMap()).toList();
    final jsonString = jsonEncode(taskMaps);
    await file.writeAsString(jsonString);
  }

  /// Load tasks from local JSON file
  Future<void> loadFromFile() async {
    final file = File(_filePath);

    if (!await file.exists()) {
      return;
    }

    final jsonString = await file.readAsString();

    if (jsonString.isEmpty) return;

    final List<dynamic> decoded = jsonDecode(jsonString);

    _tasks.clear();
    _tasks.addAll(decoded.map((map) => Task.fromMap(map)).toList());
  }

  // =========================
  // VALIDATION (PRIVATE)
  // =========================

  void _validateTask(Task task) {
    if (task.title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    if (task.description.trim().isEmpty) {
      throw Exception('Description cannot be empty');
    }
  }
}
