import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/task_notifier.dart';
import 'add_task_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TaskStatus? _filterStatus;
  bool _sortByDateAsc = true;
  bool _sortByPriorityHighFirst = true;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskNotifierProvider);

    return tasksAsync.when(
      data: (tasks) {
        final taskNotifier = ref.read(taskNotifierProvider.notifier);

        // Filter tasks
        List<Task> filteredTasks = tasks.where((t) {
          if (_filterStatus == null) return true;
          return t.status == _filterStatus;
        }).toList();

        // Sort by date
        filteredTasks.sort((a, b) => _sortByDateAsc
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date));

        // Sort by priority
        filteredTasks.sort((a, b) => _sortByPriorityHighFirst
            ? b.priority.index.compareTo(a.priority.index)
            : a.priority.index.compareTo(b.priority.index));

        return Scaffold(
          appBar: AppBar(title: const Text('Flutter Todo App')),
          body: SafeArea(
            child: Column(
              children: [
                // Filter Chips
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _filterStatus == null,
                        onSelected: (_) => setState(() => _filterStatus = null),
                      ),
                      FilterChip(
                        label: const Text('Pending'),
                        selected: _filterStatus == TaskStatus.pending,
                        onSelected: (_) =>
                            setState(() => _filterStatus = TaskStatus.pending),
                      ),
                      FilterChip(
                        label: const Text('Completed'),
                        selected: _filterStatus == TaskStatus.completed,
                        onSelected: (_) => setState(
                            () => _filterStatus = TaskStatus.completed),
                      ),
                    ],
                  ),
                ),

                // Sorting Chips
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      FilterChip(
                        label: Text('Sort Date ${_sortByDateAsc ? "↑" : "↓"}'),
                        selected: false,
                        onSelected: (_) =>
                            setState(() => _sortByDateAsc = !_sortByDateAsc),
                      ),
                      FilterChip(
                        label: Text(
                            'Sort Priority ${_sortByPriorityHighFirst ? "High→Low" : "Low→High"}'),
                        selected: false,
                        onSelected: (_) => setState(() =>
                            _sortByPriorityHighFirst =
                                !_sortByPriorityHighFirst),
                      ),
                    ],
                  ),
                ),

                // Statistics
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      Chip(label: Text('Total: ${tasks.length}')),
                      Chip(
                          label: Text(
                              'Pending: ${tasks.where((t) => t.status == TaskStatus.pending).length}')),
                      Chip(
                          label: Text(
                              'Completed: ${tasks.where((t) => t.status == TaskStatus.completed).length}')),
                      Chip(
                          label: Text(
                              'High Priority: ${tasks.where((t) => t.priority == TaskPriority.high).length}')),
                    ],
                  ),
                ),

                // Task List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return ListTile(
                        leading: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: task.priority == TaskPriority.low
                                ? Colors.green
                                : task.priority == TaskPriority.medium
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                        title: Text(task.title),
                        subtitle:
                            Text('${task.description} • ${task.status.name}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(task.status == TaskStatus.completed
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                              onPressed: () =>
                                  taskNotifier.toggleTaskStatus(task.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => taskNotifier.deleteTask(task.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AddTaskDialog(taskNotifier: taskNotifier),
              );
            },
            child: const Icon(Icons.whatshot),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error loading tasks: $err')),
      ),
    );
  }
}
