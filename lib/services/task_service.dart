import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class TaskService {
  final List<Task> _tasks = [];
  late final String _filePath;

  TaskService();

  // Must be called before accessing tasks
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/tasks.json';
    await loadFromFile();
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> addTask(Task task) async {
    _validateTask(task);
    _tasks.add(task);
    await saveToFile();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await saveToFile();
  }

  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].toggleStatus();
    await saveToFile();
  }

  Future<void> saveToFile() async {
    final file = File(_filePath);
    final jsonString = jsonEncode(_tasks.map((t) => t.toMap()).toList());
    await file.writeAsString(jsonString);
  }

  Future<void> loadFromFile() async {
    final file = File(_filePath);
    if (!await file.exists()) return;
    final jsonString = await file.readAsString();
    if (jsonString.isEmpty) return;
    final List<dynamic> decoded = jsonDecode(jsonString);
    _tasks.clear();
    _tasks.addAll(decoded.map((map) => Task.fromMap(map)).toList());
  }

  void _validateTask(Task task) {
    if (task.title.trim().isEmpty) throw Exception('Title cannot be empty');
  }

  int get totalTasks => _tasks.length;
  int get completedTasks =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get pendingTasks =>
      _tasks.where((t) => t.status == TaskStatus.pending).length;
  int countByPriority(TaskPriority priority) =>
      _tasks.where((t) => t.priority == priority).length;
}
