enum TaskStatus { pending, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final int priority;
  final TaskStatus status;
  final DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.status = TaskStatus.pending,
    required this.date,
  });

  Task toggleStatus() {
    return copyWith(
      status: status == TaskStatus.pending
          ? TaskStatus.completed
          : TaskStatus.pending,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    int? priority,
    TaskStatus? status,
    DateTime? date,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status.name,
      'date': date.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      date: DateTime.parse(map['date']),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
    );
  }
}
