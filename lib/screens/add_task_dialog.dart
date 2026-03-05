import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/task_notifier.dart';

class AddTaskDialog extends StatefulWidget {
  final TaskNotifier taskNotifier;
  const AddTaskDialog({required this.taskNotifier, super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  final _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 8),
            DropdownButton<TaskPriority>(
              value: _priority,
              items: TaskPriority.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Row(
                    children: [
                      // Colored circle instead of emoji/icon
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: p == TaskPriority.low
                              ? Colors.green
                              : p == TaskPriority.medium
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(p.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _priority = val);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final task = Task(
              id: _uuid.v4(),
              title: _titleController.text,
              description: _descController.text,
              priority: _priority,
              status: TaskStatus.pending,
              date: DateTime.now(),
            );
            await widget.taskNotifier.addTask(task);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
