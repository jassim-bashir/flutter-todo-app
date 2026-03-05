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

  Task toggleStatus() => copyWith(
      status: status == TaskStatus.pending
          ? TaskStatus.completed
          : TaskStatus.pending);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority.name,
        'status': status.name,
        'date': date.toIso8601String(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        priority:
            TaskPriority.values.firstWhere((p) => p.name == map['priority']),
        status: TaskStatus.values.firstWhere((s) => s.name == map['status']),
        date: DateTime.parse(map['date']),
      );
}
