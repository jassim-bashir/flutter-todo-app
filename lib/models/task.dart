/// Task Model
/// Handles the data structure and logic for a single task

enum TaskStatus { pending, completed }

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.date,
  });

  /// Creates a copy of this Task with optional updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? date,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }

  /// Toggle between pending and completed
  Task toggleStatus() {
    return copyWith(
      status: status == TaskStatus.pending
          ? TaskStatus.completed
          : TaskStatus.pending,
    );
  }

  // =========================
  // PERSISTENCE METHODS ADDED
  // =========================

  /// Convert Task to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name, // enum as string
      'status': status.name, // enum as string
      'date': date.toIso8601String(),
    };
  }

  /// Create Task from Map (JSON decoding)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == map['priority'],
      ),
      status: TaskStatus.values.firstWhere((s) => s.name == map['status']),
      date: DateTime.parse(map['date']),
    );
  }
}
