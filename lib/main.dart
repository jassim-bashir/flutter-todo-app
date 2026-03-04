import 'package:flutter/material.dart';
import 'package:todo_app/services/task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final taskService = TaskService();
  await taskService.loadTasks();
  runApp(MyApp(taskService: taskService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required TaskService taskService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text("Todo App"))),
    );
  }
}
