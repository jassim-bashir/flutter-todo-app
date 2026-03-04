import '../models/task.dart';

class TaskService {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _validateTask(task);
    _tasks.add(task);
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index == -1) {
      throw Exception('Task not found');
    }

    _validateTask(updatedTask);
    _tasks[index] = updatedTask;
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      throw Exception('Task not found');
    }

    _tasks[index] = _tasks[index].toggleStatus();
  }

  List<Task> search(String query) {
    final lowerQuery = query.toLowerCase();

    return _tasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
          task.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<Task> filterByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  List<Task> filterByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

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

  int get totalTasks => _tasks.length;

  int get completedTasks =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;

  int get pendingTasks =>
      _tasks.where((t) => t.status == TaskStatus.pending).length;

  int countByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).length;
  }

  void _validateTask(Task task) {
    if (task.title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    if (task.description.trim().isEmpty) {
      throw Exception('Description cannot be empty');
    }
  }
}
